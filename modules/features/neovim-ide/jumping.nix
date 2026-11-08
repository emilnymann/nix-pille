_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.flash = {
        enable = true;
      };

      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "s";
          __unkeyed-2.__raw = ''function() require("flash").jump() end'';
          mode = ["n" "x" "o"];
          desc = "Flash";
          silent = false;
        }
        {
          __unkeyed-1 = "S";
          __unkeyed-2.__raw = ''function() require("flash").treesitter() end'';
          mode = ["n" "o" "x"];
          desc = "Flash Treesitter";
          silent = false;
        }
        {
          __unkeyed-1 = "r";
          __unkeyed-2.__raw = ''function() require("flash").remote() end'';
          mode = ["o"];
          desc = "Flash remote";
          silent = false;
        }
        {
          __unkeyed-1 = "R";
          __unkeyed-2.__raw = ''function() require("flash").treesitter_search() end'';
          mode = ["o" "x"];
          desc = "Treesitter Search";
          silent = false;
        }
      ];
    };
  };
}
