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

      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<C-t>";
          __unkeyed-2.__raw = "function() Snacks.terminal() end";
          mode = ["i" "n" "t"];
          desc = "Toggle terminal";
          silent = false;
        }
      ];
    };
  };
}
