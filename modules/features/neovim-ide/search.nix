_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        which-key = {
          enable = true;
          settings.spec = [
            {
              __unkeyed-1 = "<leader>s";
              group = "Search";
            }
          ];
        };

        snacks = {
          enable = true;
          settings = {
            picker = {
              enabled = true;
            };
          };
        };

        grug-far = {
          enable = true;
          settings = {
            headerMaxWidth = 80;
          };
        };
      };

      keymaps = [
        {
          mode = ["n"];
          key = "<leader><space>";
          action.__raw = "function() Snacks.picker.smart() end";
          options = {
            desc = "Find files";
          };
        }
        {
          mode = ["n"];
          key = "<leader>sg";
          action.__raw = "function() Snacks.picker.grep() end";
          options = {
            desc = "Grep project";
          };
        }
        {
          mode = ["n"];
          key = "<leader>sw";
          action.__raw = "function() Snacks.picker.grep_word() end";
          options = {
            desc = "Grep word under cursor";
          };
        }
        {
          mode = ["n"];
          key = "<leader>sr";
          action.__raw = "function() Snacks.picker.recent() end";
          options = {
            desc = "Recent files";
          };
        }
        {
          mode = ["n"];
          key = "<leader>sp";
          action.__raw = "function() Snacks.picker.resume() end";
          options = {
            desc = "Resume picker";
          };
        }
        {
          mode = ["n"];
          key = "<leader>ss";
          action.__raw = "function() Snacks.picker.lsp_symbols() end";
          options = {
            desc = "LSP symbols";
          };
        }
        {
          mode = ["n"];
          key = "<leader>sS";
          action.__raw = "function() Snacks.picker.lsp_workspace_symbols() end";
          options = {
            desc = "LSP workspace symbols";
          };
        }
        {
          mode = ["n" "x"];
          key = "<leader>sR";
          action.__raw = ''
            function()
              local grug = require("grug-far")
              local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
              grug.open({
                transient = true,
                prefills = {
                  filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                },
              })
            end
          '';
          options = {
            desc = "Search and Replace";
          };
        }
      ];
    };
  };
}
