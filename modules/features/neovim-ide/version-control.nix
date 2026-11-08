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
      ];
    };
  };
}
