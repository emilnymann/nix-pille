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
          options = {desc = "Focus";};
        }
        {
          key = "<leader>aa";
          action.__raw = ''function() require("sidekick.cli").toggle({ name = "pi", focus = true }) end'';
          options = {desc = "Toggle";};
        }
        {
          key = "<leader>ad";
          action.__raw = ''function() require("sidekick.cli").close() end'';
          options = {desc = "Close";};
        }
        {
          key = "<leader>av";
          action.__raw = ''function() require("sidekick.cli").send({ name = "pi", msg = "{selection}" }) end'';
          mode = ["x"];
          options = {desc = "Send visual selection";};
        }
        {
          key = "<leader>af";
          action.__raw = ''function() require("sidekick.cli").send({ name = "pi", msg = "{file}" }) end'';
          options = {desc = "Send current file";};
        }
      ];
    };
  };
}
