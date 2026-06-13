_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        which-key = {
          enable = true;
        };
      };

      keymaps = [
        {
          mode = [
            "n"
          ];
          key = "<leader>?";
          action.__raw = ''function() require("which-key").show({ global = false }) end'';
          options = {
            desc = "Buffer keymaps";
          };
        }
      ];
    };
  };
}
