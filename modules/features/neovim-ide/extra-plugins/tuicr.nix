{
  inputs,
  self,
  ...
}: {
  flake-file.inputs.tuicr = {
    url = "github:xendarboh/tuicr.nvim";
    flake = false;
  };

  perSystem = {pkgs, ...}: {
    packages.tuicr = pkgs.vimUtils.buildVimPlugin {
      pname = "tuicr.nvim";
      version = let
        d = inputs.tuicr.lastModifiedDate;
      in "0-unstable-${pkgs.lib.substring 0 4 d}-${pkgs.lib.substring 4 2 d}-${pkgs.lib.substring 6 2 d}";

      src = inputs.tuicr;
    };
  };

  flake.homeModules.neovim-ide = _: {
    programs.nixvim.imports = [
      ({
        lib,
        pkgs,
        ...
      }:
        inputs.nixvim.lib.nixvim.plugins.mkNeovimPlugin {
          name = "tuicr";
          moduleName = "tuicr";

          # tuicr is not in nixpkgs, so provide its package manually.
          package = lib.mkOption {
            type = lib.types.package;
            default = self.packages.${pkgs.stdenv.hostPlatform.system}.tuicr;
          };

          maintainers = [];

          settingsExample = {
            ui.style = "modern";
          };
        })
    ];
  };
}
