{
  self,
  inputs,
  ...
}: {
  flake = {
    homeConfigurations.ens = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
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
        bluetooth
        coding-agent
        coding-agent-cursor
        desktop
        desktop-binds
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
