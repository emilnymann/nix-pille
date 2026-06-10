_: {
  flake.homeModules.desktop-notifications =
    { osConfig, lib, ... }:
    lib.mkIf osConfig.programs.hyprland.enable {
      services.mako = {
        enable = true;
      };
    };
}
