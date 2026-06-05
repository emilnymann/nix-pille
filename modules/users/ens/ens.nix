{ self, inputs, ... }:
{
  flake = {
    homeConfigurations.ens = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
      modules = [
        self.homeModules.ens
        {
          home.username = "ens";
          home.homeDirectory = "/home/ens";
        }
      ];
    };

    homeModules.ens = _: {
      imports = with self.homeModules; [
        desktop
        desktop-notifications
        theming
        file-browser
        web-browser
        neovim-ide
        git-gui
        password-manager
        smart-shell
        terminal-emulator
        tridactyl
      ];

      xdg.enable = true;

      home.stateVersion = "26.05";

      programs.rbw.settings.email = "emilnymann96@gmail.com";

      programs.git.settings = {
        user = {
          name = "Emil Nymann Sølyst";
          email = "emilnymann96@gmail.com";
          signingkey = "45E51048D62204CCD70B633B31D710749D7D8E7B";
        };
        commit = {
          gpgsign = true;
        };
        tag = {
          gpgsign = true;
        };
      };

      services.hyprpaper.settings.wallpaper = [
        {
          monitor = "";
          path = "${./wallpapers}";
        }
      ];
    };
  };
}
