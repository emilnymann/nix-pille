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

        plugins.conform-nvim.settings.formatters_by_ft = {
          javascript = ["biome"];
          javascriptreact = ["biome"];
          typescript = ["biome"];
          typescriptreact = ["biome"];
        };
      };
    };
  };
}
