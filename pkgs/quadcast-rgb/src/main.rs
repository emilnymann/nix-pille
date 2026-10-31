//! quadcast-rgb: one-shot RGB control for the HyperX QuadCast S.
//!
//! Talks to the mic's RGB controller (USB 0951:171f, interface 0) using raw
//! SET_REPORT control transfers, replicating the wire protocol documented in
//! OpenRGB's HyperXMicrophoneController (by Matt Silva, GPL-2.0-or-later):
//! <https://gitlab.com/CalcProgrammer1/OpenRGB/-/blob/master/Controllers/HyperXMicrophoneController>
//!
//! The QuadCast S has onboard flash for its RGB state. `save` writes a static
//! color frame to flash: the color persists across reboots, power cycles and
//! machines with no host software running. `set` only applies to RAM (the
//! controller falls back to its saved/default pattern after a few seconds
//! without a host feeding it). `stream` continuously feeds a color like the
//! QuadcastRGB/OpenRGB keepalive daemons do.
//!
//! Usage:
//!   quadcast-rgb save   RRGGBB [RRGGBB-bottom] [-b 0-100]  (persistent)
//!   quadcast-rgb set    RRGGBB [RRGGBB-bottom] [-b 0-100]  (until timeout)
//!   quadcast-rgb stream RRGGBB [RRGGBB-bottom] [-b 0-100]  (foreground loop)
//!   quadcast-rgb off                                       (save black)

use rusb::{Context, DeviceHandle, UsbContext};
use std::process::ExitCode;
use std::thread::sleep;
use std::time::Duration;

const VID: u16 = 0x0951;
const PID: u16 = 0x171F;

// USB SET_REPORT (feature report, report ID 0) on interface 0, 64-byte packets.
const BMREQ_OUT: u8 = 0x21;
const BREQ_SET_REPORT: u8 = 0x09;
const WVAL_FEATURE: u16 = 0x0300;
const WIDX_IF0: u16 = 0x0000;
const PKT_SIZE: usize = 64;
const TIMEOUT: Duration = Duration::from_millis(1000);
const GAP: Duration = Duration::from_millis(15); // OpenRGB sleeps 15 ms after every packet
const STREAM_PERIOD: Duration = Duration::from_millis(55); // QuadcastRGB frame period

const REG_APPLY: u8 = 0xF2;
const REG_SAVE_START: u8 = 0x53;
const REG_POST_SAVE: u8 = 0x02;
const REG_SAVE_STOP: u8 = 0x23;

type Packet = [u8; PKT_SIZE];
type Rgb = [u8; 3];

const USAGE: &str = "\
quadcast-rgb: one-shot RGB control for the HyperX QuadCast S (0951:171f)

usage: quadcast-rgb <command> [colors...] [-b 0-100]

commands:
  save   RRGGBB [RRGGBB-bottom]  write static color to onboard flash (persistent, no daemon)
  set    RRGGBB [RRGGBB-bottom]  apply color to RAM only (reverts on timeout/power cycle)
  stream RRGGBB [RRGGBB-bottom]  continuously feed color (foreground; Ctrl-C to stop)
  off                            save black (RGB off) to flash
  reset                          software-reset the RGB function (like a replug)

options:
  -b, --brightness 0-100           scale color brightness
  -f, --frames N                   saved sequence length (default 40)

examples:
  quadcast-rgb save f20000          # solid red, persistent
  quadcast-rgb save 4c0099 ff6000   # purple top, yellow bottom, persistent
  quadcast-rgb save ff6000 -b 40    # dimmed
  quadcast-rgb off                  # LEDs off, persistent";

fn reg_packet(reg: u8, p1: u8, p2: u8) -> Packet {
    let mut b = [0u8; PKT_SIZE];
    b[0] = 0x04;
    b[1] = reg;
    b[7] = p1;
    b[8] = p2;
    b
}

/// One animation frame: 0x81 R G B (top) 0x81 R G B (bottom).
fn frame_packet(top: Rgb, bot: Rgb) -> Packet {
    let mut b = [0u8; PKT_SIZE];
    b[0] = 0x81;
    b[1..4].copy_from_slice(&top);
    b[4] = 0x81;
    b[5..8].copy_from_slice(&bot);
    b
}

/// A save-data packet holding up to 8 identical frames (64 bytes).
fn fill_packet(top: Rgb, bot: Rgb, frames: usize) -> Packet {
    let mut b = [0u8; PKT_SIZE];
    for i in 0..frames.min(8) {
        b[i * 8] = 0x81;
        b[i * 8 + 1..i * 8 + 4].copy_from_slice(&top);
        b[i * 8 + 4] = 0x81;
        b[i * 8 + 5..i * 8 + 8].copy_from_slice(&bot);
    }
    b
}

fn eot_packet(num_frames: u8) -> Packet {
    let mut b = [0u8; PKT_SIZE];
    b[0] = 0x08;
    b[0x3B] = 0x28;
    b[0x3C] = num_frames;
    b[0x3E] = 0xAA;
    b[0x3F] = 0x55;
    b
}

fn send_raw(handle: &DeviceHandle<Context>, packet: &Packet) -> rusb::Result<()> {
    let n = handle.write_control(
        BMREQ_OUT,
        BREQ_SET_REPORT,
        WVAL_FEATURE,
        WIDX_IF0,
        packet,
        TIMEOUT,
    )?;
    if n != PKT_SIZE {
        return Err(rusb::Error::Other);
    }
    Ok(())
}

fn send(handle: &DeviceHandle<Context>, packet: &Packet) -> rusb::Result<()> {
    send_raw(handle, packet)?;
    sleep(GAP);
    Ok(())
}

/// Display-mode packets (0xF2 header + color frame) must be sent as an
/// atomic pair: the device ignores the frame if there is a delay after the
/// header (unlike the flash-save registers, which tolerate the 15 ms gap).
fn send_display_frame(handle: &DeviceHandle<Context>, top: Rgb, bot: Rgb) -> rusb::Result<()> {
    send_raw(handle, &reg_packet(REG_APPLY, 0, 1))?;
    send_raw(handle, &frame_packet(top, bot))?;
    Ok(())
}

fn send_all(handle: &DeviceHandle<Context>, packets: &[Packet]) -> rusb::Result<()> {
    for p in packets {
        send(handle, p)?;
    }
    Ok(())
}

fn open_device() -> rusb::Result<DeviceHandle<Context>> {
    let ctx = Context::new()?;
    for dev in ctx.devices()?.iter() {
        let Ok(desc) = dev.device_descriptor() else {
            continue;
        };
        if desc.vendor_id() == VID && desc.product_id() == PID {
            let handle = dev.open().inspect_err(|e| {
                if *e == rusb::Error::Access {
                    eprintln!(
                        "error: permission denied opening {VID:04x}:{PID:04x}.\n\
                         Install the udev rule from the quadcast-rgb NixOS module \
                         (nixos-rebuild switch), or run with sudo."
                    );
                }
            })?;
            // EP0 control transfers don't strictly need a claimed interface on
            // Linux, but claim interface 0 when free to serialize with other
            // host software.
            let _ = handle.claim_interface(0);
            return Ok(handle);
        }
    }
    Err(rusb::Error::NoDevice)
}

/// Show the color now (RAM only).
fn apply_direct(handle: &DeviceHandle<Context>, top: Rgb, bot: Rgb) -> rusb::Result<()> {
    send_display_frame(handle, top, bot)?;
    sleep(GAP);
    Ok(())
}

/// Write the color to onboard flash as a sequence of identical frames,
/// then show it. The device stores an animation; saving just one frame
/// leaves the previous animation's frames behind, so fill the sequence.
fn save_flash(handle: &DeviceHandle<Context>, top: Rgb, bot: Rgb, frames: u8) -> rusb::Result<()> {
    let num_packets = frames.div_ceil(8) as usize;
    let mut seq = Vec::with_capacity(num_packets + 7);
    seq.push(reg_packet(REG_SAVE_START, num_packets as u8, 0)); // start save
    for i in 0..num_packets {
        let in_packet = (frames as usize - i * 8).min(8);
        seq.push(fill_packet(top, bot, in_packet));
    }
    seq.push(reg_packet(REG_POST_SAVE, 0, 0));
    seq.push(reg_packet(REG_SAVE_STOP, 1, 0));
    seq.push(eot_packet(frames)); // end of transaction
    seq.push(reg_packet(REG_POST_SAVE, 0, 0));
    send_all(handle, &seq)?;
    // The device likes one direct packet after the save (atomic pair).
    send_display_frame(handle, top, bot)
}

fn parse_color(s: &str, brightness: u8) -> Result<Rgb, String> {
    let s = s.strip_prefix('#').unwrap_or(s);
    if s.len() != 6 || !s.bytes().all(|b| b.is_ascii_hexdigit()) {
        return Err(format!("invalid color '{s}', want RRGGBB"));
    }
    let mut rgb = [0u8; 3];
    for (i, v) in rgb.iter_mut().enumerate() {
        let c = u8::from_str_radix(&s[2 * i..2 * i + 2], 16).map_err(|e| e.to_string())?;
        *v = ((u16::from(c) * u16::from(brightness) + 50) / 100) as u8;
    }
    Ok(rgb)
}

fn parse_args() -> Result<(String, Rgb, Rgb, u8), String> {
    let mut args = std::env::args().skip(1);
    let command = args.next().unwrap_or_default();
    if command.is_empty() || command == "-h" || command == "--help" {
        return Err(USAGE.to_string());
    }
    if !["save", "set", "stream", "off", "reset"].contains(&command.as_str()) {
        return Err(format!("unknown command '{command}'\n\n{USAGE}"));
    }

    let mut colors: Vec<String> = Vec::new();
    let mut brightness: u8 = 100;
    let mut frames: u8 = 40; // NGenuity captures show a 40-frame saved sequence
    let mut rest = args.peekable();
    while let Some(a) = rest.next() {
        match a.as_str() {
            "-b" | "--brightness" => {
                let v = rest.next().ok_or("missing value for -b")?;
                brightness = v
                    .parse::<u8>()
                    .ok()
                    .filter(|b| *b <= 100)
                    .ok_or("brightness must be 0-100")?;
            }
            "-f" | "--frames" => {
                let v = rest.next().ok_or("missing value for -f")?;
                frames = v
                    .parse::<u8>()
                    .ok()
                    .filter(|f| *f >= 1)
                    .ok_or("frames must be 1-255")?;
            }
            _ => colors.push(a),
        }
    }

    if command == "off" || command == "reset" {
        return Ok((command, [0; 3], [0; 3], frames));
    }
    let Some(top) = colors.first() else {
        return Err(format!("'{command}' needs at least one color (RRGGBB)\n\n{USAGE}"));
    };
    let top = parse_color(top, brightness)?;
    let bot = match colors.get(1) {
        Some(c) => parse_color(c, brightness)?,
        None => top,
    };
    Ok((command, top, bot, frames))
}

fn run() -> Result<(), String> {
    let (command, top, bot, frames) = parse_args()?;
    let handle = open_device().map_err(|e| match e {
        rusb::Error::NoDevice => format!(
            "HyperX QuadCast S RGB controller ({VID:04x}:{PID:04x}) not found (unplugged?)"
        ),
        rusb::Error::Access => String::new(), // hint already printed
        e => format!("USB error: {e}"),
    })?;

    match command.as_str() {
        "save" | "off" => {
            save_flash(&handle, top, bot, frames).map_err(|e| e.to_string())?;
            println!("saved {frames}-frame sequence to device flash; no daemon needed from now on");
        }
        "reset" => {
            // Re-enumerate the RGB function so the mic reboots into its saved
            // state without a physical replug. The handle dies with the reset.
            handle.reset().map_err(|e| e.to_string())?;
            println!("device reset; it should now boot into the saved state");
        }
        "set" => {
            apply_direct(&handle, top, bot).map_err(|e| e.to_string())?;
            println!("applied (RAM only; reverts when the mic is power-cycled or times out)");
        }
        "stream" => {
            println!("streaming color (Ctrl-C to stop)...");
            loop {
                if send_display_frame(&handle, top, bot).is_err() {
                    // The mic was unplugged (or re-enumerated): exit cleanly so
                    // the systemd service stops without triggering a restart.
                    println!("device gone, stopping");
                    return Ok(());
                }
                sleep(STREAM_PERIOD);
            }
        }
        _ => unreachable!(),
    }
    Ok(())
}

fn main() -> ExitCode {
    match run() {
        Ok(()) => ExitCode::SUCCESS,
        Err(msg) => {
            if !msg.is_empty() {
                eprintln!("{msg}");
            }
            ExitCode::FAILURE
        }
    }
}
