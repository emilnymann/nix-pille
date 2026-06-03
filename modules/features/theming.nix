_: {
  flake.nixosModules.theming =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
        cursor = {
          name = "rose-pine-hyprcursor";
          package = pkgs.rose-pine-hyprcursor;
          size = 24;
        };

        targets.kmscon.enable = false;
      };
    };

  flake.homeModules.theming =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
        cursor = {
          name = "rose-pine-hyprcursor";
          package = pkgs.rose-pine-hyprcursor;
          size = 24;
        };
      };
    };
}
