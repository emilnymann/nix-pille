_: {
  flake.nixosModules.theming =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
        targets.kmscon.enable = false;
      };
    };

  flake.homeModules.theming =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      withNixvim = config.programs.nixvim.enable;
    in
    {
      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
        fonts = {
          monospace = {
            package = pkgs.maple-mono.NF;
            name = "Maple Mono NF";
          };
          serif = {
            package = pkgs.nerd-fonts.noto;
            name = "NotoSerif Nerd Font";
          };
          sansSerif = {
            package = pkgs.nerd-fonts.noto;
            name = "NotoSans Nerd Font";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
      };

      home.pointerCursor = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
        let
          getFrom = url: hash: name: {
            gtk.enable = true;
            x11.enable = true;
            name = name;
            size = 24;
            package = pkgs.runCommand "moveUp" { } ''
              mkdir -p $out/share/icons
              ln -s ${
                pkgs.fetchzip {
                  url = url;
                  hash = hash;
                }
              } $out/share/icons/${name}
            '';
          };
        in
        getFrom "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Dark.tar.xz"
          "sha256-HqjO/ogAd/dsrO5WHIilUQaq1CbiU48lEaoefcUmmBM="
          "BreezeX-Dark"
      );

      programs.nixvim.colorschemes = lib.mkIf withNixvim {
        gruvbox-material = {
          enable = true;
          autoLoad = true;
        };
      };
    };
}
