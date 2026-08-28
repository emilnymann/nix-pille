{
  self,
  inputs,
  ...
}: {
  flake = {
    darwinConfigurations.cobalt = inputs.nix-darwin.lib.darwinSystem {
      modules = [
        self.darwinModules.cobalt
        self.darwinModules.gpg-ssh
        self.darwinModules.myHomeManager
        self.darwinModules.theming
      ];
    };

    darwinModules.cobalt = {pkgs, ...}: {
      imports = [
        self.darwinModules."macos-base"
        self.darwinModules."work-apps"
        self.darwinModules.desktop
      ];

      networking.hostName = "cobalt";

      system.primaryUser = "ens";
      users.users.ens = {
        home = "/Users/ens";
        shell = pkgs.fish;
      };

      home-manager.users.ens = {
        imports = [
          self.homeModules.ens-darwin-laptop
        ];

        home.username = "ens";
        home.homeDirectory = "/Users/ens";

        programs.fish.shellAbbrs = {
          drs = "sudo nix run nix-darwin -- switch --flake ~/nix#cobalt";
        };
      };

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
    };
  };
}
