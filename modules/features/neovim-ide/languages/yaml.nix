_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            yamlls = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
