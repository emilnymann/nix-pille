_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        tuicr = {
          enable = true;
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
          group = "History (File)";
          icon = {
            icon = "󱋡";
            color = "purple";
          };
        }
        {
          __unkeyed-1 = "<leader>vR";
          group = "Review";
          icon = {
            icon = "";
            color = "green";
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
      ];
    };
  };
}
