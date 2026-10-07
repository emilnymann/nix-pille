_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            vtsls.enable = true;
            denols.enable = true;
            biome.enable = true;
          };
        };
      };
    };
  };
}
