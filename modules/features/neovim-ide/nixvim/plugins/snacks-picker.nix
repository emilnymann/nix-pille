_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>s";
          group = "Search";
        }
      ];

      plugins = {
        snacks = {
          enable = true;
          settings = {
            picker = {
              enabled = true;
            };
          };
        };
      };

      keymaps = [
        {
          mode = [
            "n"
          ];
          key = "<leader><space>";
          action.__raw = "function() Snacks.picker.smart() end";
          options = {
            desc = "Find files";
          };
        }
        {
          mode = [
            "n"
          ];
          key = "<leader>sg";
          action.__raw = "function() Snacks.picker.grep() end";
          options = {
            desc = "Grep project";
          };
        }
        {
          mode = [
            "n"
          ];
          key = "<leader>sw";
          action.__raw = "function() Snacks.picker.grep_word() end";
          options = {
            desc = "Grep word under cursor";
          };
        }
        {
          mode = [
            "n"
          ];
          key = "<leader>sr";
          action.__raw = "function() Snacks.picker.recent() end";
          options = {
            desc = "Recent files";
          };
        }
        {
          mode = [
            "n"
          ];
          key = "<leader>ss";
          action.__raw = "function() Snacks.picker.lsp_symbols() end";
          options = {
            desc = "LSP symbols";
          };
        }
        {
          mode = [
            "n"
          ];
          key = "<leader>sS";
          action.__raw = "function() Snacks.picker.lsp_workspace_symbols() end";
          options = {
            desc = "LSP workspace symbols";
          };
        }
      ];
    };
  };
}
