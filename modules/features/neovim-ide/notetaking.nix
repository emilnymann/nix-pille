_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        neorg = {
          enable = true;
          settings = {
            load = {
              "core.defaults" = {__empty = null;};
              "core.concealer" = {__empty = null;};
            };
          };
        };
      };
    };
  };
}
