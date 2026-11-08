_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        yanky.enable = true;

        which-key.settings.spec = [
          {
            __unkeyed-1 = "y";
            __unkeyed-2 = "<Plug>(YankyYank)";
            mode = ["n" "x"];
            desc = "Yank";
            silent = false;
          }
          {
            __unkeyed-1 = "p";
            __unkeyed-2 = "<Plug>(YankyPutAfter)";
            mode = ["n" "x"];
            desc = "Put";
            silent = false;
          }
          {
            __unkeyed-1 = "P";
            __unkeyed-2 = "<Plug>(YankyPutBefore)";
            mode = ["n" "x"];
            desc = "Put";
            silent = false;
          }
          {
            __unkeyed-1 = "gp";
            __unkeyed-2 = "<Plug>(YankyGPutAfter)";
            mode = ["n" "x"];
            desc = "Put";
            silent = false;
          }
          {
            __unkeyed-1 = "gP";
            __unkeyed-2 = "<Plug>(YankyGPutBefore)";
            mode = ["n" "x"];
            desc = "Put)";
            silent = false;
          }
          {
            __unkeyed-1 = "<leader>p";
            __unkeyed-2 = "<cmd>YankyRingHistory<cr>";
            mode = ["n" "x"];
            silent = false;
            desc = "Yank History";
            icon = {
              icon = "";
              color = "yellow";
            };
          }
        ];
      };
    };
  };
}
