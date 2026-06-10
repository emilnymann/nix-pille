_: {
  flake.homeModules.desktop =
    { osConfig, lib, ... }:
    lib.mkIf osConfig.programs.hyprland.enable {
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
          kb_layout = "dk";
          kb_variant = "nodeadkeys";
          kb_options = "ctrl:nocaps";
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
