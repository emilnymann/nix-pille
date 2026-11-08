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
              __unkeyed-2 = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
              mode = ["n" "v" "o"];
              silent = false;
              desc = "Buffer";
              icon = {
                icon = "󰈔";
                color = "blue";
              };
            }
            {
              __unkeyed-1 = "<leader>xX";
              __unkeyed-2 = "<cmd>Trouble diagnostics toggle<cr>";
              mode = ["n" "v" "o"];
              silent = false;
              desc = "Workspace";
              icon = {
                icon = "󰙅";
                color = "azure";
              };
            }
            {
              __unkeyed-1 = "<leader>xl";
              __unkeyed-2.__raw = "vim.diagnostic.open_float";
              silent = false;
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
    };
  };
}
