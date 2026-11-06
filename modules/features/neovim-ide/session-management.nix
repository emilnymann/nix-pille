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
            icon = {
              icon = "";
              color = "azure";
            };
          }
          {
            __unkeyed-1 = "<leader>Sq";
            desc = "Save & Quit";
            icon = {
              icon = "󰆓";
              color = "green";
            };
          }
          {
            __unkeyed-1 = "<leader>SQ";
            desc = "Quit!";
            icon = {
              icon = "󰗼";
              color = "red";
            };
          }
          {
            __unkeyed-1 = "<leader>Sr";
            desc = "Restore";
            icon = {
              icon = "";
              color = "cyan";
            };
          }
          {
            __unkeyed-1 = "<leader>Ss";
            desc = "Select";
            icon = {
              icon = "󱂬";
              color = "blue";
            };
          }
          {
            __unkeyed-1 = "<leader>Sd";
            desc = "Disable Saving";
            icon = {
              icon = "󰅙";
              color = "yellow";
            };
          }
        ];
      };

      keymaps = [
        {
          key = "<leader>Sq";
          action = "<cmd>wq<cr>";
          options = {desc = "Save & Quit";};
        }
        {
          key = "<leader>SQ";
          action = "<cmd>q!<cr>";
          options = {desc = "Quit!";};
        }
        {
          key = "<leader>Sr";
          action.__raw = ''function() require("persistence").load() end'';
          options = {desc = "Restore";};
        }
        {
          key = "<leader>Ss";
          action.__raw = ''function() require("persistence").select() end'';
          options = {desc = "Select";};
        }
        {
          key = "<leader>Ss";
          action.__raw = ''function() require("persistence").load({ last = true }) end'';
          options = {desc = "Restore Last";};
        }
        {
          key = "<leader>Sd";
          action.__raw = ''function() require("persistence").stop() end'';
          options = {desc = "Disable Saving";};
        }
      ];
    };
  };
}
