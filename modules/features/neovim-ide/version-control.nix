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
          desc = "History (File)";
          icon = {
            icon = "󱋡";
            color = "purple";
          };
        }
        {
          __unkeyed-1 = "<leader>vR";
          desc = "Review";
          icon = {
            icon = "";
            color = "green";
          };
        }
        {
          __unkeyed-1 = "<leader>vd";
          desc = "Diff";
          icon = {
            icon = "";
            color = "yellow";
          };
        }
        {
          __unkeyed-1 = "<leader>vD";
          desc = "Diff (Pick)";
          icon = {
            icon = "";
            color = "yellow";
          };
        }
      ];

      keymaps = [
        {
          mode = ["n"];
          key = "<leader>vf";
          action.__raw = "function() Snacks.picker.git_log_file() end";
          options = {
            desc = "History (File)";
          };
        }
        {
          mode = ["n"];
          key = "<leader>vR";
          action = "<cmd>Tuicr<cr>";
          options = {
            desc = "Review";
          };
        }
        {
          mode = ["n"];
          key = "<leader>vd";
          action = "<cmd>Difft<cr>";
          options = {
            desc = "Diff";
          };
        }
        {
          mode = ["n"];
          key = "<leader>vD";
          action = "<cmd>DifftPick<cr>";
          options = {
            desc = "Diff (Pick)";
          };
        }
      ];
    };
  };
}
