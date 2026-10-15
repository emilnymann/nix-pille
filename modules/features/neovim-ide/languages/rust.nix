_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            rust_analyzer = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
