_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        yanky.enable = true;

        which-key.settings.spec = [
          {
            __unkeyed-1 = "<leader>p";
            desc = "Open yank history";
          }
        ];
      };

      keymaps = [
        {
          mode = ["n" "x"];
          key = "<leader>p";
          action = "<cmd>YankyRingHistory<cr>";
          options = {desc = "Open yank history";};
        }
        {
          mode = ["n" "x"];
          key = "y";
          action = "<Plug>(YankyYank)";
          options = {desc = "Yank text";};
        }
        {
          mode = ["n" "x"];
          key = "p";
          action = "<Plug>(YankyPutAfter)";
          options = {desc = "Put yanked text after cursor";};
        }
        {
          mode = ["n" "x"];
          key = "P";
          action = "<Plug>(YankyPutBefore)";
          options = {desc = "Put yanked text before cursor";};
        }
        {
          mode = ["n" "x"];
          key = "gp";
          action = "<Plug>(YankyGPutAfter)";
          options = {desc = "Put yanked text after cursor and leave cursor after";};
        }
        {
          mode = ["n" "x"];
          key = "gP";
          action = "<Plug>(YankyGPutBefore)";
          options = {desc = "Put yanked text before cursor and leave cursor after";};
        }
        {
          mode = ["n"];
          key = "<c-p>";
          action = "<Plug>(YankyPreviousEntry)";
          options = {desc = "Select previous entry through yank history";};
        }
        {
          mode = ["n"];
          key = "<c-n>";
          action = "<Plug>(YankyNextEntry)";
          options = {desc = "Select next entry through yank history";};
        }
        {
          mode = ["n"];
          key = "]p";
          action = "<Plug>(YankyPutIndentAfterLinewise)";
          options = {desc = "Put indented after cursor (linewise)";};
        }
        {
          mode = ["n"];
          key = "[p";
          action = "<Plug>(YankyPutIndentBeforeLinewise)";
          options = {desc = "Put indented before cursor (linewise)";};
        }
        {
          mode = ["n"];
          key = "]P";
          action = "<Plug>(YankyPutIndentAfterLinewise)";
          options = {desc = "Put indented after cursor (linewise)";};
        }
        {
          mode = ["n"];
          key = "[P";
          action = "<Plug>(YankyPutIndentBeforeLinewise)";
          options = {desc = "Put indented before cursor (linewise)";};
        }
        {
          mode = ["n"];
          key = ">p";
          action = "<Plug>(YankyPutIndentAfterShiftRight)";
          options = {desc = "Put and indent right";};
        }
        {
          mode = ["n"];
          key = "<p";
          action = "<Plug>(YankyPutIndentAfterShiftLeft)";
          options = {desc = "Put and indent left";};
        }
        {
          mode = ["n"];
          key = ">P";
          action = "<Plug>(YankyPutIndentBeforeShiftRight)";
          options = {desc = "Put before and indent right";};
        }
        {
          mode = ["n"];
          key = "<P";
          action = "<Plug>(YankyPutIndentBeforeShiftLeft)";
          options = {desc = "Put before and indent left";};
        }
        {
          mode = ["n"];
          key = "=p";
          action = "<Plug>(YankyPutAfterFilter)";
          options = {desc = "Put after applying a filter";};
        }
        {
          mode = ["n"];
          key = "=P";
          action = "<Plug>(YankyPutBeforeFilter)";
          options = {desc = "Put before applying a filter";};
        }
      ];
    };
  };
}
