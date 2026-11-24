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

    homeModules.janeski = _: {
      imports = with self.homeModules; [
        bitwarden
        bluetooth
        desktop
        desktop-binds
        discord
        file-browser
        music-player
        neovim-ide
        nix-helper
        password-manager
        smart-shell
        terminal-emulator
        theming
        version-control
        web-browser
      ];

      xdg.enable = true;
      home.stateVersion = "26.05";
    };
  };
}
