_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            marksman = {
              enable = true;
            };
          };
        };

        plugins = {
          render-markdown = {
            enable = true;
            settings = {
              code = {
                sign = false;
                width = "block";
                right_pad = 1;
              };
              heading = {
                sign = false;
                icons.__empty = null;
              };
            };
          };
        };
      };
    };
  };
}
