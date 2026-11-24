_: {
  flake.homeModules.janeski = {
    config,
    lib,
    pkgs,
    ...
  }: {
    features.theming = {
      colorscheme = "atlas";
      cursor = lib.mkIf pkgs.stdenv.hostPlatform.isLinux "BreezeX-Dark";
    };

    stylix.targets.firefox.profileNames = [config.home.username];
  };
}
