_: {
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
          pkgs.xdg-desktop-portal-gtk
        ];
      };

      fonts.packages = with pkgs; [ font-awesome_4 ];
      programs.waybar.enable = true;
    };

  flake.homeModules.desktop =
    { lib, nixosConfig, ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        systemd = lib.mkIf nixosConfig.programs.hyprland.withUWSM {
          enable = false;
        };

        settings = {
          launcher = {
            _var = "hyprlauncher";
          };

          terminal = {
            _var = "ghostty";
          };

          browser = {
            _var = "firefox";
          };

          filemanager = {
            _var = "ghostty --title=yazi -e yazi";
          };

          config = {
            general = {
              gaps_in = 4;
              gaps_out = 12;
            };
            decoration = {
              rounding = 8;
            };
            input = {
              kb_model = "pc104";
              kb_layout = "dk";
              kb_variant = "nodeadkeys";
              kb_options = "terminate:ctrl_alt_bksp";
            };
            misc = {
              vrr = 1;
            };
            cursor = {
              inactive_timeout = 6;
            };
          };

          monitor = {
            output = "DP-1";
            mode = "2560x1440@165";
            position = "auto";
            scale = 1;
            vrr = 1;
          };

          bind =
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
                  "SUPER + SHIFT + B"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(browser)")
                  { description = "Browser"; }
                ];
              }
              {
                _args = [
                  "SUPER + SHIFT + F"
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
                    "SUPER + SHIFT + ${key}"
                    (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = '${dir}' })")
                    { description = "Move window <${dir}>"; }
                  ];
                }
              ]) directionKeys
            ))

            ++ [
              {
                _args = [
                  "SUPER + S"
                  (lib.generators.mkLuaInline "hl.dsp.workspace.toggle_special('scratch')")
                  { description = "Toggle scratchpad"; }
                ];
              }
              {
                _args = [
                  "SUPER + SHIFT + S"
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
                    "SUPER + SHIFT + ${toString i}"
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
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd('wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+')")
                  { description = "Raise volume"; }
                ];
              }
              {
                _args = [
                  "XF86AudioLowerVolume"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd('wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-')")
                  { description = "Lower volume"; }
                ];
              }
              {
                _args = [
                  "XF86AudioMute"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle')")
                  { description = "Mute volume"; }
                ];
              }
            ];
        };
      };
    };
}
