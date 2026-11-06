{inputs, ...}: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.imports = [
      ({
        lib,
        pkgs,
        ...
      }: let
        tuicr = pkgs.vimUtils.buildVimPlugin {
          name = "tuicr";

          src = pkgs.fetchFromGitHub {
            owner = "xendarboh";
            repo = "tuicr.nvim";
            rev = "8b84a000ecc2126ffd2394c188a23f83912779ea";
            hash = "sha256-HwDUq4aXRGLaoy6IgnMqldRCtlT0UrZKyhL4qqBOrds=";
          };

          postPatch = "rm plugin/tuicr.vim";
        };
      in
        inputs.nixvim.lib.nixvim.plugins.mkNeovimPlugin {
          name = "tuicr";
          moduleName = "tuicr";

          package = lib.mkOption {
            type = lib.types.package;
            default = tuicr;
          };

          maintainers = [];

          settingsExample = {
            ui.style = "modern";
          };
        })
    ];
  };
}
