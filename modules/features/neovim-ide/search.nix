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
            desc = "Smart Picker";
          };
        }
        {
          mode = ["n"];
          key = "<leader>sg";
          action.__raw = "function() Snacks.picker.grep() end";
          options = {
            desc = "Grep Project";
          };
        }
        {
          mode = ["n"];
          key = "<leader>sw";
          action.__raw = "function() Snacks.picker.grep_word() end";
          options = {
            desc = "Grep Word";
          };
        }
        {
          mode = ["x"];
          key = "<leader>sg";
          action.__raw = "function() Snacks.picker.grep_word() end";
          options = {
            desc = "Grep Visual";
          };
        }
        {
          mode = ["n"];
          key = "<leader>sr";
          action.__raw = "function() Snacks.picker.recent() end";
          options = {
            desc = "Recent Files";
          };
        }
        {
          mode = ["n"];
          key = "<leader>sp";
          action.__raw = "function() Snacks.picker.resume() end";
          options = {
            desc = "Resume Picker";
          };
        }
        {
          mode = ["n"];
          key = "<leader>ss";
          action.__raw = "function() Snacks.picker.lsp_symbols() end";
          options = {
            desc = "Symbols";
          };
        }
        {
          mode = ["n"];
          key = "<leader>sS";
          action.__raw = "function() Snacks.picker.lsp_workspace_symbols() end";
          options = {
            desc = "Symbols (Workspace)";
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
            desc = "Replace";
          };
        }
      ];
    };
  };
}
