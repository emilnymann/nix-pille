_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        lspconfig = {
          enable = true;
        };
      };

      lsp = {
        servers = {
          phpantom_lsp = {
            enable = true;
          };
        };
      };
    };
  };
}
