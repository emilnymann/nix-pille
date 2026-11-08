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
            {
              __unkeyed-1 = "<leader><space>";
              __unkeyed-2.__raw = "function() Snacks.picker.smart() end";
              desc = "Smart Picker";
              silent = false;
            }
            {
              __unkeyed-1 = "<leader>sg";
              __unkeyed-2.__raw = "function() Snacks.picker.grep() end";
              desc = "Grep Project";
              silent = false;
            }
            {
              __unkeyed-1 = "<leader>sw";
              __unkeyed-2.__raw = "function() Snacks.picker.grep_word() end";
              desc = "Grep Word";
              silent = false;
            }
            {
              __unkeyed-1 = "<leader>sg";
              __unkeyed-2.__raw = "function() Snacks.picker.grep_word() end";
              mode = ["x"];
              desc = "Grep Visual";
              silent = false;
            }
            {
              __unkeyed-1 = "<leader>sr";
              __unkeyed-2.__raw = "function() Snacks.picker.recent() end";
              desc = "Recent Files";
              silent = false;
            }
            {
              __unkeyed-1 = "<leader>sp";
              __unkeyed-2.__raw = "function() Snacks.picker.resume() end";
              desc = "Resume Picker";
              silent = false;
            }
            {
              __unkeyed-1 = "<leader>ss";
              __unkeyed-2.__raw = "function() Snacks.picker.lsp_symbols() end";
              desc = "Symbols";
              silent = false;
            }
            {
              __unkeyed-1 = "<leader>sS";
              __unkeyed-2.__raw = "function() Snacks.picker.lsp_workspace_symbols() end";
              desc = "Symbols (Workspace)";
              silent = false;
            }
            {
              __unkeyed-1 = "<leader>sR";
              __unkeyed-2.__raw = ''
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
              mode = ["n" "x"];
              desc = "Replace";
              silent = false;
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
    };
  };
}
