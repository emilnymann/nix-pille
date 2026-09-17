_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            tailwindcss = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
