{
  inputs,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.tuicr = pkgs.vimUtils.buildVimPlugin {
      pname = "tuicr.nvim";
      version = "0-unstable-2026-04-11";

      src = pkgs.fetchFromGitHub {
        owner = "xendarboh";
        repo = "tuicr.nvim";
        rev = "8b84a000ecc2126ffd2394c188a23f83912779ea";
        hash = "sha256-HwDUq4aXRGLaoy6IgnMqldRCtlT0UrZKyhL4qqBOrds=";
      };

      # tuicr registers its own user command in plugin/. Nixvim generates the
      # setup call instead.
      postPatch = "rm plugin/tuicr.lua";
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
