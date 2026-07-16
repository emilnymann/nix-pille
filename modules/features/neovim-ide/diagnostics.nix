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
            }
          ];
        };
      };

      keymaps = [
        {
          key = "<leader>xx";
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
          options = { desc = "Buffer diagnostics"; };
        }
        {
          key = "<leader>xX";
          action = "<cmd>Trouble diagnostics toggle<cr>";
          options = { desc = "Workspace diagnostics"; };
        }
      ];
    };
  };
}
