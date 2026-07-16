_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.flash = {
        enable = true;
      };

      keymaps = [
        {
          mode = ["n" "x" "o"];
          key = "s";
          action.__raw = ''function() require("flash").jump() end'';
          options = { desc = "Flash"; };
        }
        {
          mode = ["n" "o" "x"];
          key = "S";
          action.__raw = ''function() require("flash").treesitter() end'';
          options = { desc = "Flash Treesitter"; };
        }
        {
          mode = ["o"];
          key = "r";
          action.__raw = ''function() require("flash").remote() end'';
          options = { desc = "Flash remote"; };
        }
        {
          mode = ["o" "x"];
          key = "R";
          action.__raw = ''function() require("flash").treesitter_search() end'';
          options = { desc = "Treesitter Search"; };
        }
      ];
    };
  };
}
