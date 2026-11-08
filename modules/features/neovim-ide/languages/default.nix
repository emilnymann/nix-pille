_: {
  flake.homeModules.neovim-ide = _: {
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
              __unkeyed-2.__raw = "function() Snacks.picker.lsp_definitions() end";
              silent = false;
              mode = ["n"];
              desc = "Definition";
              icon = {
                icon = "󰊕";
                color = "azure";
              };
            }
            {
              __unkeyed-1 = "gr";
              __unkeyed-2.__raw = "function() Snacks.picker.lsp_references() end";
              nowait = true;
              silent = false;
              mode = ["n"];
              desc = "Reference";
              icon = {
                icon = "󰈇";
                color = "green";
              };
            }
            {
              __unkeyed-1 = "gI";
              __unkeyed-2.__raw = "function() Snacks.picker.lsp_implementations() end";
              silent = false;
              mode = ["n"];
              desc = "Implementation";
              icon = {
                icon = "󰡱";
                color = "purple";
              };
            }
            {
              __unkeyed-1 = "gy";
              __unkeyed-2.__raw = "function() Snacks.picker.lsp_type_definitions() end";
              silent = false;
              mode = ["n"];
              desc = "T[y]pe Definition";
              icon = {
                icon = "󰜁";
                color = "cyan";
              };
            }
            {
              __unkeyed-1 = "gD";
              __unkeyed-2.__raw = "function() Snacks.picker.lsp_declarations() end";
              silent = false;
              mode = ["n"];
              desc = "Declaration";
              icon = {
                icon = "󰙅";
                color = "yellow";
              };
            }
            {
              __unkeyed-1 = "K";
              __unkeyed-2.__raw = "function() vim.lsp.buf.hover() end";
              silent = false;
              mode = ["n"];
              desc = "Hover";
              icon = {
                icon = "󰋼";
                color = "blue";
              };
            }
            {
              __unkeyed-1 = "<leader>ca";
              __unkeyed-2.__raw = "function() vim.lsp.buf.code_action() end";
              silent = false;
              mode = ["n" "v"];
              desc = "Action";
              icon = {
                icon = "󰌵";
                color = "yellow";
              };
            }
            {
              __unkeyed-1 = "<leader>cA";
              __unkeyed-2.__raw = ''
                function()
                  vim.lsp.buf.code_action({
                    context = {
                      only = { "source" },
                      diagnostics = {},
                    },
                  })
                end
              '';
              silent = false;
              mode = ["n" "v"];
              desc = "Action (Source)";
              icon = {
                icon = "󰆧";
                color = "orange";
              };
            }
            {
              __unkeyed-1 = "<leader>cr";
              __unkeyed-2.__raw = "function() vim.lsp.buf.rename() end";
              silent = false;
              mode = ["n"];
              desc = "Rename Symbol";
              icon = {
                icon = "󰑕";
                color = "green";
              };
            }
            {
              __unkeyed-1 = "gK";
              __unkeyed-2.__raw = "function() vim.lsp.buf.signature_help() end";
              silent = false;
              mode = ["n"];
              desc = "Signature Help";
              icon = {
                icon = "󰘥";
                color = "purple";
              };
            }
            {
              __unkeyed-1 = "<c-k>";
              __unkeyed-2.__raw = "function() vim.lsp.buf.signature_help() end";
              silent = false;
              mode = ["i"];
              desc = "Signature Help";
              icon = {
                icon = "󰘥";
                color = "purple";
              };
            }
            {
              __unkeyed-1 = "<c-f>";
              __unkeyed-2.__raw = ''
                function()
                  require("conform").format({ async = false })
                end
              '';
              silent = false;
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
    };
  };
}
