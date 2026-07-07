_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      lsp.servers.copilot.enable = true;
      plugins = {
        sidekick = {
          enable = true;
          settings = {
            cli = {
              tools = {
                pi = {};
              };
            };
          };
        };
      };

      keymaps = [
        {
          key = "<C-a>";
          action.__raw = ''function() require("sidekick").nes_jump_or_apply() end'';
          options = {desc = "Goto/Apply next edit suggestion";};
        }
        {
          mode = ["n" "t" "i" "x"];
          key = "<C-.>";
          action.__raw = ''function() require("sidekick.cli").focus() end'';
          options = {desc = "Sidekick - Focus";};
        }
        {
          key = "<leader>aa";
          action.__raw = ''function() require("sidekick.cli").toggle() end'';
          options = {desc = "Sidekick - Toggle";};
        }
        {
          key = "<leader>ad";
          action.__raw = ''function() require("sidekick.cli").close() end'';
          options = {desc = "Sidekick - Close";};
        }
      ];
    };
  };
}
