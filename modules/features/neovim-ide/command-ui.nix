_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        plugins = {
          noice = {
            enable = true;
            settings = {
              lsp = {
                hover = {
                  silent = true;
                };
              };
            };
          };

          snacks = {
            settings = {
              notifier = {
                enabled = true;
              };
            };
          };
        };
      };
    };
  };
}
