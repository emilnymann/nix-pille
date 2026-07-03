{
  inputs,
  lib,
  moduleLocation,
  ...
}:
let
  inherit (lib) mapAttrs mkOption types;
in
{
  options.flake.darwinModules = mkOption {
    type = types.lazyAttrsOf types.deferredModule;
    default = { };
    apply = mapAttrs (k: v: {
      _class = "darwin";
      _file = "${toString moduleLocation}#darwinModules.${k}";
      imports = [ v ];
    });
    description = "nix-darwin modules.";
  };

  config.flake.darwinModules.myHomeManager = _: {
    imports = [
      inputs.home-manager.darwinModules.default
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
    };
  };
}
