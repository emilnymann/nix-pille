_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed-1 = "<leader>?";
            desc = "Keys";
            icon = {
              icon = "";
              color = "cyan";
            };
          }
        ];
      };

      keymaps = [
        {
          mode = ["n"];
          key = "<leader>?";
          action.__raw = ''function() require("which-key").show({ global = false }) end'';
          options = {
            desc = "Keys";
          };
        }
      ];
    };
  };
}
