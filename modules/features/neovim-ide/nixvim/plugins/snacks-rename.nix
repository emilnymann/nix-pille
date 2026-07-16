_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        snacks = {
          enable = true;
          settings = {
            rename = {
              enabled = true;
            };
          };
        };
      };

      keymaps = [
        {
          mode = ["n"];
          key = "<leader>cR";
          action.__raw = "function() Snacks.rename.rename_file() end";
          options = {desc = "Rename file";};
        }
      ];
    };
  };
}
