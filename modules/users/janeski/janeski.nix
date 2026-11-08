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

    homeModules.janeski = {
      imports = with self.homeModules; [
        desktop
        bluetooth
        file-browser
        web-browser
        web-browser-private-profiles
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
