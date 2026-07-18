_: {
  flake.homeModules.desktop = {
    osConfig,
    lib,
    ...
  }:
    lib.mkIf osConfig.programs.hyprland.enable {
      wayland.windowManager.hyprland.settings.animation = [
        {
          leaf = "specialWorkspace";
          enabled = true;
          speed = 6;
          bezier = "default";
          style = "slidevert";
        }
      ];

      wayland.windowManager.hyprland.settings.window_rule = [
        {
          name = "screenshot-annotate-overlay";
          match.class = "^dev\\.ens\\.ScreenshotAnnotate$";
          float = true;
          center = true;
          focus_on_activate = true;
          stay_focused = true;
        }
      ];

      wayland.windowManager.hyprland.settings.config = {
        general = {
          gaps_in = 4;
          gaps_out = 4;
        };

        decoration = {
          rounding = 8;
        };

        input = {
          kb_model = "pc104";
          kb_layout = "us";
          kb_variant = "";
          kb_options = "ctrl:nocaps";

          touchpad = {
            natural_scroll = true;
          };
        };

        misc = {
          vrr = 1;
        };

        cursor = {
          inactive_timeout = 6;
        };

        binds = {
          hide_special_on_workspace_change = true;
        };
      };
    };
}
