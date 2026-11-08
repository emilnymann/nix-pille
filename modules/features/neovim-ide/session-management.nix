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
            __unkeyed-2 = "<cmd>wq<cr>";
            mode = ["n" "v" "o"];
            silent = false;
            desc = "Save & Quit";
            icon = {
              icon = "󰆓";
              color = "green";
            };
          }
          {
            __unkeyed-1 = "<leader>SQ";
            __unkeyed-2 = "<cmd>q!<cr>";
            mode = ["n" "v" "o"];
            silent = false;
            desc = "Quit!";
            icon = {
              icon = "󰗼";
              color = "red";
            };
          }
          {
            __unkeyed-1 = "<leader>Sr";
            __unkeyed-2.__raw = ''function() require("persistence").load() end'';
            mode = ["n" "v" "o"];
            silent = false;
            desc = "Restore";
            icon = {
              icon = "";
              color = "cyan";
            };
          }
          {
            __unkeyed-1 = "<leader>Ss";
            __unkeyed-2.__raw = ''function() require("persistence").select() end'';
            mode = ["n" "v" "o"];
            silent = false;
            desc = "Select";
            icon = {
              icon = "󱂬";
              color = "blue";
            };
          }
          {
            __unkeyed-1 = "<leader>SR";
            __unkeyed-2.__raw = ''function() require("persistence").load({ last = true }) end'';
            mode = ["n" "v" "o"];
            desc = "Restore Last";
            icon = {
              icon = "";
              color = "cyan";
            };
            silent = false;
          }
          {
            __unkeyed-1 = "<leader>Sd";
            __unkeyed-2.__raw = ''function() require("persistence").stop() end'';
            mode = ["n" "v" "o"];
            silent = false;
            desc = "Disable Saving";
            icon = {
              icon = "󰅙";
              color = "yellow";
            };
          }
        ];
      };
    };
  };
}
