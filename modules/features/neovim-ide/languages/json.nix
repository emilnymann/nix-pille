_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            jsonls = {
              enable = true;
            };
          };
        };

        plugins.conform-nvim.settings.formatters_by_ft = {
          json = ["biome"];
          jsonc = ["biome"];
        };
      };
    };
  };
}
