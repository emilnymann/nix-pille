{self, ...}: {
  flake.homeModules.ens-linux-desktop = {config, pkgs, ...}: {
    imports = with self.homeModules; [
      desktop
      bluetooth
      file-browser
      web-browser
      terminal-emulator
      theming
      discord
      bitwarden
    ];

    programs.glide-browser.profiles.${config.home.username} = {
      isDefault = true;
      name = config.home.username;
    };

    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      name = "BreezeX-Dark";
      size = 24;
      package = pkgs.runCommand "moveUp" {} ''
        mkdir -p $out/share/icons
        ln -s ${
          pkgs.fetchzip {
            url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Dark.tar.xz";
            hash = "sha256-HqjO/ogAd/dsrO5WHIilUQaq1CbiU48lEaoefcUmmBM=";
          }
        } $out/share/icons/BreezeX-Dark
      '';
    };

    services.hyprpaper.settings.wallpaper = [
      {
        monitor = "";
        path = "${./wallpapers}";
      }
    ];
  };
}
