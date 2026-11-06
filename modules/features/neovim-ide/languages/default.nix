_: {
  flake.homeModules.neovim-ide = {
    config,
    lib,
    ...
  }: {
    programs.nixvim = {
      plugins = {
        lspconfig.enable = true;
        which-key = {
          enable = true;
          settings.spec = [
            {
              __unkeyed-1 = "<leader>c";
              group = "Code";
              icon = {
                icon = "";
                color = "cyan";
              };
            }
            {
              __unkeyed-1 = "g";
              mode = ["n"];
              group = "Goto";
              icon = {
                icon = "󰁔";
                color = "blue";
              };
            }
            {
              __unkeyed-1 = "gd";
              mode = ["n"];
              desc = "Definition";
              icon = {
                icon = "󰊕";
                color = "azure";
              };
            }
            {
              __unkeyed-1 = "gr";
              mode = ["n"];
              desc = "Reference";
              icon = {
                icon = "󰈇";
                color = "green";
              };
            }
            {
              __unkeyed-1 = "gI";
              mode = ["n"];
              desc = "Implementation";
              icon = {
                icon = "󰡱";
                color = "purple";
              };
            }
            {
              __unkeyed-1 = "gy";
              mode = ["n"];
              desc = "T[y]pe Definition";
              icon = {
                icon = "󰜁";
                color = "cyan";
              };
            }
            {
              __unkeyed-1 = "gD";
              mode = ["n"];
              desc = "Declaration";
              icon = {
                icon = "󰙅";
                color = "yellow";
              };
            }
            {
              __unkeyed-1 = "K";
              mode = ["n"];
              desc = "Hover";
              icon = {
                icon = "󰋼";
                color = "blue";
              };
            }
            {
              __unkeyed-1 = "<leader>ca";
              mode = ["n" "v"];
              desc = "Action";
              icon = {
                icon = "󰌵";
                color = "yellow";
              };
            }
            {
              __unkeyed-1 = "<leader>cA";
              mode = ["n" "v"];
              desc = "Action (Source)";
              icon = {
                icon = "󰆧";
                color = "orange";
              };
            }
            {
              __unkeyed-1 = "<leader>cr";
              mode = ["n"];
              desc = "Rename Symbol";
              icon = {
                icon = "󰑕";
                color = "green";
              };
            }
            {
              __unkeyed-1 = "gK";
              mode = ["n"];
              desc = "Signature Help";
              icon = {
                icon = "󰘥";
                color = "purple";
              };
            }
            {
              __unkeyed-1 = "<c-k>";
              mode = ["i"];
              desc = "Signature Help";
              icon = {
                icon = "󰘥";
                color = "purple";
              };
            }
            {
              __unkeyed-1 = "<c-f>";
              mode = ["n" "v"];
              desc = "Format";
              icon = {
                icon = "󰉢";
                color = "cyan";
              };
            }
          ];
        };
      };

      keymaps = [
        {
          mode = ["n"];
          key = "gd";
          action.__raw = "function() Snacks.picker.lsp_definitions() end";
          options = {desc = "Definition";};
        }
        {
          mode = ["n"];
          key = "gr";
          action.__raw = "function() Snacks.picker.lsp_references() end";
          options = {
            desc = "Reference";
            nowait = true;
          };
        }
        {
          mode = ["n"];
          key = "gI";
          action.__raw = "function() Snacks.picker.lsp_implementations() end";
          options = {desc = "Implementation";};
        }
        {
          mode = ["n"];
          key = "gy";
          action.__raw = "function() Snacks.picker.lsp_type_definitions() end";
          options = {desc = "T[y]pe Definition";};
        }
        {
          mode = ["n"];
          key = "gD";
          action.__raw = "function() Snacks.picker.lsp_declarations() end";
          options = {desc = "Declaration";};
        }
        {
          mode = ["n"];
          key = "K";
          action.__raw = "function() vim.lsp.buf.hover() end";
          options = {desc = "Hover";};
        }
        {
          mode = ["n" "v"];
          key = "<leader>ca";
          action.__raw = "function() vim.lsp.buf.code_action() end";
          options = {desc = "Action";};
        }
        {
          mode = ["n" "v"];
          key = "<leader>cA";
          action.__raw = ''
            function()
              vim.lsp.buf.code_action({
                context = {
                  only = { "source" },
                  diagnostics = {},
                },
              })
            end
          '';
          options = {desc = "Action (Source)";};
        }
        {
          mode = ["n"];
          key = "<leader>cr";
          action.__raw = "function() vim.lsp.buf.rename() end";
          options = {desc = "Rename Symbol";};
        }
        {
          mode = ["n"];
          key = "gK";
          action.__raw = "function() vim.lsp.buf.signature_help() end";
          options = {desc = "Signature Help";};
        }
        {
          mode = ["i"];
          key = "<c-k>";
          action.__raw = "function() vim.lsp.buf.signature_help() end";
          options = {desc = "Signature Help";};
        }
        {
          mode = ["n" "v"];
          key = "<c-f>";
          action.__raw = ''
            function()
              require("conform").format({ async = false })
            end
          '';
          options = {desc = "Format";};
        }
      ];
    };
  };
}
