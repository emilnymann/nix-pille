_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        snacks = {
          enable = true;
          settings = {
            statuscolumn.enabled = true;
          };
        };
      };
    };
  };
}
