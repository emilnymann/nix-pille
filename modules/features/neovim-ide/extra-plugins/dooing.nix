{inputs, ...}: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.imports = [
      ({lib, pkgs, ...}: let
        dooing = pkgs.vimUtils.buildVimPlugin {
          name = "dooing";

          src = pkgs.fetchFromGitHub {
            owner = "atiladefreitas";
            repo = "dooing";
            rev = "bc461143ce49335c0058a25f317da6ce5fed29be";
            hash = "sha256-P3pxrseboW0J/wBpEPP+bXm33FQUO0tUNj4rLz5kZFs=";
          };

          # Dooing calls setup() itself. Nixvim will generate the setup call instead.
          postPatch = "rm plugin/dooing.vim";
        };
      in
        inputs.nixvim.lib.nixvim.plugins.mkNeovimPlugin {
          name = "dooing";
          moduleName = "dooing";

          # Dooing is not in nixpkgs, so provide its package manually.
          package = lib.mkOption {
            type = lib.types.package;
            default = dooing;
          };

          maintainers = [];

          settingsExample = {
            ui.style = "modern";
          };
        })
    ];
  };
}
