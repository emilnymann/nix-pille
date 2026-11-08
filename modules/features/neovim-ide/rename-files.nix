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

      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>cR";
          __unkeyed-2.__raw = "function() Snacks.rename.rename_file() end";
          desc = "Rename file";
          silent = false;
        }
      ];
    };
  };
}
