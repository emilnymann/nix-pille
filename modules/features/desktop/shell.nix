_: {
  flake.homeModules.desktop = {osConfig, lib, ...}:
    lib.mkIf osConfig.programs.hyprland.enable {
      programs.ashell = {
        enable = true;
        systemd.enable = true;
      };
    };
}
