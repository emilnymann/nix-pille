_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        tuicr = {
          enable = true;
        };

        difftastic = {
          enable = true;
          settings = {
            snacks_picker.enabled = true;
          };
        };

        snacks = {
          enable = true;
          settings = {
            picker = {
              enabled = true;
            };
          };
        };

        jj = {
          enable = true;
          settings = {
            editor.window.type = "floating";
          };
        };
      };

      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>v";
          group = "Version Control";
          icon = {
            icon = "";
            color = "cyan";
          };
        }
        {
          __unkeyed-1 = "<leader>vf";
          __unkeyed-2.__raw = "function() Snacks.picker.git_log_file() end";
          silent = false;
          desc = "History (File)";
          icon = {
            icon = "󱋡";
            color = "purple";
          };
        }
        {
          __unkeyed-1 = "<leader>vR";
          __unkeyed-2 = "<cmd>Tuicr<cr>";
          silent = false;
          desc = "Review";
          icon = {
            icon = "";
            color = "green";
          };
        }
        {
          __unkeyed-1 = "<leader>vd";
          __unkeyed-2 = "<cmd>Difft<cr>";
          silent = false;
          desc = "Diff";
          icon = {
            icon = "";
            color = "yellow";
          };
        }
        {
          __unkeyed-1 = "<leader>vD";
          __unkeyed-2 = "<cmd>DifftPick<cr>";
          silent = false;
          desc = "Diff (Pick)";
          icon = {
            icon = "";
            color = "yellow";
          };
        }

        {
          __unkeyed-1 = "<leader>vj";
          group = "Jujutsu";
          icon = {
            icon = "";
            color = "cyan";
          };
        }
        {
          __unkeyed-1 = "<leader>vj?";
          __unkeyed-2 = "<cmd>J status<cr>";
          desc = "Status";
          icon = {
            icon = "󱖫";
            color = "green";
          };
        }
        {
          __unkeyed-1 = "<leader>vjl";
          __unkeyed-2 = "<cmd>J log<cr>";
          desc = "Log";
          icon = {
            icon = "";
            color = "green";
          };
        }
        {
          __unkeyed-1 = "<leader>vjd";
          __unkeyed-2 = "<cmd>J describe<cr>";
          desc = "Describe";
          icon = {
            icon = "";
            color = "green";
          };
        }
        {
          __unkeyed-1 = "<leader>vjn";
          __unkeyed-2 = "<cmd>J new<cr>";
          desc = "New";
          icon = {
            icon = "󰐚";
            color = "yellow";
          };
        }
        {
          __unkeyed-1 = "<leader>vjp";
          __unkeyed-2 = "<cmd>J push<cr>";
          desc = "Push";
          icon = {
            icon = "";
            color = "purple";
          };
        }
        {
          __unkeyed-1 = "<leader>vjf";
          __unkeyed-2 = "<cmd>J fetch<cr>";
          desc = "Fetch";
          icon = {
            icon = "";
            color = "purple";
          };
        }
        {
          __unkeyed-1 = "<leader>vjs";
          __unkeyed-2 = "<cmd>J split<cr>";
          desc = "Split";
          icon = {
            icon = "󰃻";
            color = "cyan";
          };
        }
        {
          __unkeyed-1 = "<leader>vjr";
          __unkeyed-2 = "<cmd>J rebase<cr>";
          desc = "Rebase";
          icon = {
            icon = "";
            color = "orange";
          };
        }
        {
          __unkeyed-1 = "<leader>vjR";
          __unkeyed-2 = "<cmd>J resolve<cr>";
          desc = "Resolve";
          icon = {
            icon = "󰁨";
            color = "purple";
          };
        }
        {
          __unkeyed-1 = "<leader>vjo";
          __unkeyed-2 = "<cmd>J open_pr<cr>";
          desc = "Open PR";
          icon = {
            icon = "";
            color = "green";
          };
        }
        {
          __unkeyed-1 = "<leader>vjD";
          __unkeyed-2 = "<cmd>J diff<cr>";
          desc = "Diff";
          icon = {
            icon = "";
            color = "yellow";
          };
        }
      ];
    };
  };
}
