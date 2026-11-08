{
  self,
  inputs,
  ...
}: {
  flake = {
    homeConfigurations.janeski = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
      modules = [
        self.homeModules.janeski
        {
          home.username = "janeski";
          home.homeDirectory = "/home/janeski";
        }
      ];
    };

    homeModules.janeski = {config, pkgs, ...}: {
      imports = with self.homeModules; [
        desktop
        bluetooth
        file-browser
        web-browser
        terminal-emulator
        theming
        discord
        bitwarden
        neovim-ide
        version-control
        smart-shell
        coding-agent
        coding-agent-cursor
        password-manager
        music-player
        nix-helper
      ];

      programs.firefox.profiles.${config.home.username} = {
        isDefault = true;
        name = config.home.username;
      };

      stylix.targets.firefox.profileNames = [config.home.username];

      stylix = {
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

      programs.nixvim.colorschemes.gruvbox-material = {
        enable = true;
        autoLoad = true;
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

      programs.git.settings = {
        user = {
          name = "Yevheniia Sakharova";
          email = "sjane1504@gmail.com";
        };
      };

      programs.jujutsu.settings = {
        user = {
          name = "Yevheniia Sakharova";
          email = "sjane1504@gmail.com";
        };
      };

      xdg.enable = true;
      home.stateVersion = "26.05";
    };
  };
}
