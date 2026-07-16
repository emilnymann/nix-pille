_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.trouble = {
        enable = true;
      };

      keymaps = [
        {
          key = "<leader>xx";
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
          options = { desc = "Buffer Diagnostics (Trouble)"; };
        }
        {
          key = "<leader>xX";
          action = "<cmd>Trouble diagnostics toggle<cr>";
          options = { desc = "Workspace Diagnostics (Trouble)"; };
        }
      ];
    };
  };
}
