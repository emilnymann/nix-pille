_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            gopls = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
