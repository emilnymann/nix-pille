{
  inputs,
  self,
  ...
}: {
  flake-file.inputs.dooing = {
    url = "github:atiladefreitas/dooing";
    flake = false;
  };

  perSystem = {pkgs, ...}: {
    packages.dooing = pkgs.vimUtils.buildVimPlugin {
      pname = "dooing";
      version = let
        d = inputs.dooing.lastModifiedDate;
      in "0-unstable-${pkgs.lib.substring 0 4 d}-${pkgs.lib.substring 4 2 d}-${pkgs.lib.substring 6 2 d}";

      src = inputs.dooing;

      # Dooing calls setup() itself. Nixvim will generate the setup call instead.
      postPatch = "rm plugin/dooing.vim";
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
          name = "dooing";
          moduleName = "dooing";

          # Dooing is not in nixpkgs, so provide its package manually.
          package = lib.mkOption {
            type = lib.types.package;
            default = self.packages.${pkgs.stdenv.hostPlatform.system}.dooing;
          };

          maintainers = [];

          settingsExample = {
            ui.style = "modern";
          };
        })
    ];
  };
}
