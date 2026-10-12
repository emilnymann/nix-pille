_: {
  flake.homeModules.neovim-ide = _: {
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
