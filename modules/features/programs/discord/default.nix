_: {
  flake.homeModules.discord =
    { osConfig, lib, ... }:
    lib.mkIf osConfig.programs.hyprland.enable {
      programs.discord.enable = true;
    };
}
