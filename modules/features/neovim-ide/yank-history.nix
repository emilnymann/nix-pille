_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        yanky.enable = true;

        which-key.settings.spec = [
          {
            __unkeyed-1 = "<leader>p";
            desc = "Yank History";
            icon = {
              icon = "";
              color = "yellow";
            };
          }
        ];
      };

      keymaps = [
        {
          mode = ["n" "x"];
          key = "<leader>p";
          action = "<cmd>YankyRingHistory<cr>";
          options = {desc = "Yank History";};
        }
        {
          mode = ["n" "x"];
          key = "y";
          action = "<Plug>(YankyYank)";
          options = {desc = "Yank";};
        }
        {
          mode = ["n" "x"];
          key = "p";
          action = "<Plug>(YankyPutAfter)";
          options = {desc = "Put";};
        }
        {
          mode = ["n" "x"];
          key = "P";
          action = "<Plug>(YankyPutBefore)";
          options = {desc = "Put";};
        }
        {
          mode = ["n" "x"];
          key = "gp";
          action = "<Plug>(YankyGPutAfter)";
          options = {desc = "Put";};
        }
        {
          mode = ["n" "x"];
          key = "gP";
          action = "<Plug>(YankyGPutBefore)";
          options = {desc = "Put)";};
        }
      ];
    };
  };
}
