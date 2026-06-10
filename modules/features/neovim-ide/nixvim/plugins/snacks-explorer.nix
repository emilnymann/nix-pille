_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        snacks = {
          enable = true;
          settings = {
            explorer = {
              enabled = true;
            };
            picker = {
              enabled = true;
            };
          };
        };
      };

      keymaps = [
        {
          mode = [
            "n"
          ];
          key = "<leader>e";
          action.__raw = "function() Snacks.explorer() end";
          options = {
            desc = "File explorer";
          };
        }
      ];
    };
  };
}
