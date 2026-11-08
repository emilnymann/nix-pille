{inputs, ...}: {
  flake.nixosModules.theming = {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = {
      enable = true;
      homeManagerIntegration.autoImport = false;
      targets.kmscon.enable = false;
    };
  };

  flake.darwinModules.theming = {
    imports = [inputs.stylix.darwinModules.stylix];
  };

  flake.homeModules.theming = {
    imports = [inputs.stylix.homeModules.stylix];

    stylix = {
      enable = true;
      overlays.enable = false;
    };
  };
}
