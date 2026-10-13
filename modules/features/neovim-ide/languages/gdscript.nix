_: {
  flake.homeModules.neovim-ide = {pkgs, ...}: {
    home.packages = [pkgs.gdtoolkit_4];

    programs = {
      nixvim = {
        lsp = {
          servers = {
            gdscript = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
