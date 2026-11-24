_: {
  flake.homeModules.desktop = {
    osConfig ? {},
    lib,
    ...
  }:
    lib.mkIf (lib.attrByPath ["programs" "hyprland" "enable"] false osConfig) {
      programs.ashell = {
        enable = true;
        systemd.enable = true;
      };
    };
}
