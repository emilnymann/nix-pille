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

    homeModules.ens = {
      imports = with self.homeModules; [
        ens-base
        ens-linux-desktop
      ];
    };
  };
}
