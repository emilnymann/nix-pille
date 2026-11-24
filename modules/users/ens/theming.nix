_: {
  flake.homeModules.ens = {
    lib,
    pkgs,
    ...
  }: {
    features.theming = {
      colorscheme = "gruvbox-material-dark-medium";
      cursor = lib.mkIf pkgs.stdenv.hostPlatform.isLinux "BreezeX-Dark";
    };
  };
}
