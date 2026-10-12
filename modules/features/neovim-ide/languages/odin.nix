_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            ols = {
              enable = true;
              config = {
                init_options = {
                  enable_snippets = true;
                };
              };
            };
          };
        };
      };
    };
  };
}
