_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        plugins.conform-nvim.settings.formatters_by_ft.gdscript = ["gdformat"];

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
