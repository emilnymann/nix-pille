_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        persistence = {
          enable = true;
        };
        which-key.settings.spec = [
          {
            __unkeyed-1 = "<leader>S";
            group = "Session";
          }
        ];
      };

      keymaps = [
        {
          key = "<leader>Sq";
          action = "<cmd>wq<cr>";
          options = {desc = "Save and Quit";};
        }
        {
          key = "<leader>SQ";
          action = "<cmd>q!<cr>";
          options = {desc = "Quit Without Saving";};
        }
        {
          key = "<leader>Sr";
          action.__raw = ''function() require("persistence").load() end'';
          options = {desc = "Restore Session";};
        }
        {
          key = "<leader>Ss";
          action.__raw = ''function() require("persistence").select() end'';
          options = {desc = "Select Session";};
        }
        {
          key = "<leader>Ss";
          action.__raw = ''function() require("persistence").load({ last = true }) end'';
          options = {desc = "Restore Last Session";};
        }
        {
          key = "<leader>Sd";
          action.__raw = ''function() require("persistence").stop() end'';
          options = {desc = "Don't Save Session";};
        }
      ];
    };
  };
}
