_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.dooing = {
        enable = true;
        settings = {
          ui.style = "modern";
          window.dimensions = {
            width = 120;
            height = 20;
          };
          calendar = {
            start_day = "monday";
          };
          keymaps = {
            toggle_window = "<leader>td";
            open_project_todo = "<leader>tD";
            new_todo = "n";
          };
        };
      };

      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>t";
          group = "Todo";
        }
      ];
    };
  };
}
