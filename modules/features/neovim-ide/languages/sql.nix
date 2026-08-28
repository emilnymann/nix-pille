_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            sqls.enable = true;
          };
        };
      };
    };
  };
}
