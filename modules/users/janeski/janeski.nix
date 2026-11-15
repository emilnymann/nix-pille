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

    homeModules.janeski = {config, osConfig, lib, ...}: {
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

      features.theming = {
        colorscheme = "gruvbox-material-dark-medium";
        cursor = "BreezeX-Dark";
      };

      wayland.windowManager.hyprland.settings.config = lib.mkIf osConfig.programs.hyprland.enable {
        general = {
          gaps_in = 4;
          gaps_out = 4;
        };

        decoration = {
          rounding = 8;
        };

        cursor = {
          inactive_timeout = 6;
        };

        input = {
          kb_model = "pc104";
          kb_layout = "dk";
          kb_options = "ctrl:nocaps,lv3:alt_switch";
          repeat_delay = 450;
          repeat_rate = 67;

          touchpad = {
            natural_scroll = true;
          };
        };
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
