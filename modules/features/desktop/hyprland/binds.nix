_: {
  flake.homeModules.desktop = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    screenshotFullscreenCopy = pkgs.writeShellScriptBin "screenshot-fullscreen-copy" ''
      set -euo pipefail
      ${lib.getExe pkgs.grim} - | ${lib.getExe' pkgs.wl-clipboard "wl-copy"} --type image/png
    '';

    screenshotSelectionGeometry = ''
      ${lib.getExe' pkgs.hyprland "hyprctl"} clients -j \
        | ${lib.getExe pkgs.jq} -r '.[] | select(.mapped) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.title)"' \
        | ${lib.getExe pkgs.slurp}
    '';

    screenshotSelectionCopy = pkgs.writeShellScriptBin "screenshot-selection-copy" ''
      set -euo pipefail
      geometry="$(${screenshotSelectionGeometry})"
      ${lib.getExe pkgs.grim} -g "$geometry" - | ${lib.getExe' pkgs.wl-clipboard "wl-copy"} --type image/png
    '';

    screenshotFullscreenAnnotate = pkgs.writeShellScriptBin "screenshot-fullscreen-annotate" ''
      set -euo pipefail
      ${lib.getExe pkgs.grim} - \
        | ${lib.getExe pkgs.satty} \
            --filename - \
            --copy-command ${lib.getExe' pkgs.wl-clipboard "wl-copy"} \
            --output-filename "~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png"
    '';

    screenshotSelectionAnnotate = pkgs.writeShellScriptBin "screenshot-selection-annotate" ''
      set -euo pipefail
      geometry="$(${screenshotSelectionGeometry})"
      ${lib.getExe pkgs.grim} -g "$geometry" - \
        | ${lib.getExe pkgs.satty} \
            --filename - \
            --copy-command ${lib.getExe' pkgs.wl-clipboard "wl-copy"} \
            --output-filename "~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png"
    '';
  in
    lib.mkIf osConfig.programs.hyprland.enable {
      wayland.windowManager.hyprland.settings = {
        bind = let
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
                {description = "Launcher";}
              ];
            }
            {
              _args = [
                "SUPER + Return"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(terminal)")
                {description = "Terminal emulator";}
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + B"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(browser)")
                {description = "Browser";}
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + F"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(filemanager)")
                {description = "Filemanager";}
              ];
            }
            {
              _args = [
                "SUPER + V"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(cliphist)")
                {description = "Clipboard history";}
              ];
            }
            {
              _args = [
                "SUPER + ALT + K"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(which_key)")
                {description = "Show keybinds";}
              ];
            }

            # Windows
            {
              _args = [
                "SUPER + W"
                (lib.generators.mkLuaInline "hl.dsp.window.close()")
                {description = "Close active window";}
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
                  {description = "Move focus ${dir}";}
                ];
              }
              {
                _args = [
                  "SUPER + SHIFT + ${key}"
                  (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = '${dir}' })")
                  {description = "Move window ${dir}";}
                ];
              }
            ])
            directionKeys
          ))
          ++ [
            {
              _args = [
                "SUPER + ae"
                (lib.generators.mkLuaInline "hl.dsp.workspace.toggle_special('scratch')")
                {description = "Toggle scratchpad";}
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + ae"
                (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 'special:scratch'})")
                {description = "Toggle scratchpad";}
              ];
            }
          ]
          ++ (lib.flatten (
            map (i: [
              {
                _args = [
                  "SUPER + ${toString i}"
                  (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = '${toString i}' })")
                  {description = "Focus workspace ${toString i}";}
                ];
              }
              {
                _args = [
                  "SUPER + SHIFT + ${toString i}"
                  (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = '${toString i}' })")
                  {description = "Move active window to workspace ${toString i}";}
                ];
              }
            ]) (lib.range 1 9)
          ))
          ++ [
            {
              _args = [
                "XF86AudioRaiseVolume"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${pkgs.wireplumber}/bin/wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+')")
                {description = "Raise volume";}
              ];
            }
            {
              _args = [
                "XF86AudioLowerVolume"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-')")
                {description = "Lower volume";}
              ];
            }
            {
              _args = [
                "XF86AudioMute"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle')")
                {description = "Mute volume";}
              ];
            }
            {
              _args = [
                "SUPER + S"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${lib.getExe screenshotFullscreenCopy}')")
                {description = "Screenshot fullscreen -> Clipboard";}
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + S"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${lib.getExe screenshotSelectionCopy}')")
                {description = "Screenshot selection -> Clipboard";}
              ];
            }
            {
              _args = [
                "Print"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${lib.getExe screenshotFullscreenAnnotate}')")
                {description = "Screenshot fullscreen -> Annotate";}
              ];
            }
            {
              _args = [
                "SUPER + Print"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${lib.getExe screenshotSelectionAnnotate}')")
                {description = "Screenshot selection -> Annotate";}
              ];
            }
          ];
      };
    };
}
