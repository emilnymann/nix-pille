_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        trouble = {
          enable = true;
        };

        which-key = {
          enable = true;
          settings.spec = [
            {
              __unkeyed-1 = "<leader>x";
              group = "Diagnostics";
              icon = {
                icon = "󱖫";
                color = "green";
              };
            }
            {
              __unkeyed-1 = "<leader>xx";
              desc = "Buffer";
              icon = {
                icon = "󰈔";
                color = "blue";
              };
            }
            {
              __unkeyed-1 = "<leader>xX";
              desc = "Workspace";
              icon = {
                icon = "󰙅";
                color = "azure";
              };
            }
            {
              __unkeyed-1 = "<leader>xl";
              desc = "Line";
              icon = {
                icon = "󰅺";
                color = "yellow";
              };
            }
          ];
        };

        lualine = {
          settings = {
            sections = {
              lualine_c = [
                {
                  __unkeyed-1 = "diagnostics";
                  symbols = {
                    error = " ";
                    warn = " ";
                    hint = " ";
                    info = " ";
                  };
                }
              ];
            };
          };
        };
      };

      keymaps = [
        {
          key = "<leader>xx";
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
          options = {desc = "Buffer";};
        }
        {
          key = "<leader>xX";
          action = "<cmd>Trouble diagnostics toggle<cr>";
          options = {desc = "Workspace";};
        }
        {
          mode = ["n"];
          key = "<leader>xl";
          action.__raw = "vim.diagnostic.open_float";
          options = {desc = "Line";};
        }
      ];
    };
  };
}
