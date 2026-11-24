_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            tofu_ls = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
