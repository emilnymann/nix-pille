_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        snacks.enable = true;

        which-key = {
          enable = true;
          settings.spec = [
          {
            __unkeyed-1 = "<leader>b";
            group = "Buffers";
          }
        ];
        };

        mini = {
          enable = true;
          mockDevIcons = true;
          modules = {
            icons = {
              enable = true;
            };
          };
        };

        bufferline = {
          enable = true;
          settings = {
            options = {
              close_command.__raw = "function(n) Snacks.bufdelete(n) end";
              diagnostics = "nvim_lsp";
              always_show_bufferline = false;
              diagnostics_indicator.__raw = ''
                function(_, _, diag)
                  return vim.trim((diag.error and " " .. diag.error .. " " or "")
                    .. (diag.warning and " " .. diag.warning or "")
                  )
                end
              '';
              offsets = [
                {
                  filetype = "neo-tree";
                  text = "Neo-tree";
                  highlight = "Directory";
                  text_align = "left";
                }
                {
                  filetype = "snacks_layout_box";
                }
              ];
            };
          };
        };
      };

      keymaps = [
        {
          mode = ["n"];
          key = "<S-h>";
          action = "<cmd>bprevious<cr>";
          options = {
            desc = "Previous buffer";
          };
        }
        {
          mode = ["n"];
          key = "<S-l>";
          action = "<cmd>bnext<cr>";
          options = {
            desc = "Next buffer";
          };
        }
        {
          mode = ["n"];
          key = "<leader>bd";
          action.__raw = "function() Snacks.bufdelete() end";
          options = {
            desc = "Delete buffer";
          };
        }
        {
          mode = ["n"];
          key = "<leader>bo";
          action.__raw = "function() Snacks.bufdelete.other() end";
          options = {
            desc = "Delete other buffers";
          };
        }
      ];
    };
  };
}
