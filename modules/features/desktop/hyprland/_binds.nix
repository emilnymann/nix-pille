{ lib, pkgs, ... }:
{
  wayland.windowManager.hyprland.settings.bind =
    let
      directionKeys = {
        H = "l";
        J = "d";
        K = "u";
        L = "r";
      };
    in
    [
      # Programs
      {
        _args = [
          "SUPER + Space"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(launcher)")
          { description = "Launcher"; }
        ];
      }
      {
        _args = [
          "SUPER + Return"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(terminal)")
          { description = "Terminal emulator"; }
        ];
      }
      {
        _args = [
          "SUPER + ALT + B"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(browser)")
          { description = "Browser"; }
        ];
      }
      {
        _args = [
          "SUPER + ALT + F"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(filemanager)")
          { description = "Filemanager"; }
        ];
      }

      # Windows
      {
        _args = [
          "SUPER + W"
          (lib.generators.mkLuaInline "hl.dsp.window.close()")
          { description = "Close active window"; }
        ];
      }
      {
        _args = [
          "SUPER + W"
          (lib.generators.mkLuaInline "hl.dsp.window.close()")
          { description = "Close active window"; }
        ];
      }
      {
        _args = [
          "SUPER + W"
          (lib.generators.mkLuaInline "hl.dsp.window.close()")
          { description = "Close active window"; }
        ];
      }
      {
        _args = [
          "SUPER + mouse:272"
          (lib.generators.mkLuaInline "hl.dsp.window.drag()")
          {
            description = "Drag window";
            mouse = true;
          }
        ];
      }
      {
        _args = [
          "SUPER + mouse:273"
          (lib.generators.mkLuaInline "hl.dsp.window.resize()")
          {
            description = "Resize window";
            mouse = true;
          }
        ];
      }

      ## Power menu
      {
        _args = [
          "SUPER + Escape"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(power_menu)")
          {
            description = "Power menu";
          }
        ];
      }
    ]

    ++ (lib.flatten (
      lib.mapAttrsToList (key: dir: [
        {
          _args = [
            "SUPER + ${key}"
            (lib.generators.mkLuaInline "hl.dsp.focus({ direction = '${dir}' })")
            { description = "Move focus <${dir}>"; }
          ];
        }
        {
          _args = [
            "SUPER + ALT + ${key}"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = '${dir}' })")
            { description = "Move window <${dir}>"; }
          ];
        }
      ]) directionKeys
    ))

    ++ [
      {
        _args = [
          "SUPER + ae"
          (lib.generators.mkLuaInline "hl.dsp.workspace.toggle_special('scratch')")
          { description = "Toggle scratchpad"; }
        ];
      }
      {
        _args = [
          "SUPER + ALT + ae"
          (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 'special:scratch'})")
          { description = "Toggle scratchpad"; }
        ];
      }
    ]

    ++ (lib.flatten (
      map (i: [
        {
          _args = [
            "SUPER + ${toString i}"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '${toString i}' })")
            { description = "Focus workspace ${toString i}"; }
          ];
        }
        {
          _args = [
            "SUPER + ALT + ${toString i}"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = '${toString i}' })")
            { description = "Move active window to workspace <${toString i}>"; }
          ];
        }
      ]) (lib.range 1 9)
    ))
    ++ [
      {
        _args = [
          "XF86AudioRaiseVolume"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${pkgs.wireplumber}/bin/wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+')")
          { description = "Raise volume"; }
        ];
      }
      {
        _args = [
          "XF86AudioLowerVolume"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-')")
          { description = "Lower volume"; }
        ];
      }
      {
        _args = [
          "XF86AudioMute"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle')")
          { description = "Mute volume"; }
        ];
      }
    ];
}
