_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        snacks = {
          enable = true;
          settings = {
            terminal = {
              enabled = true;
            };
          };
        };
      };

      keymaps = [
        {
          mode = [
            "n"
            "t"
          ];
          key = "<C-t>";
          action.__raw = "function() Snacks.terminal() end";
          options = {
            desc = "Terminal";
          };
        }
      ];
    };
  };
}
