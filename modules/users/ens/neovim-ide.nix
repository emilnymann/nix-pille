_: {
  flake.homeModules.ens = _: {
    programs.nixvim = {
      opts = {
        exrc = true;
        undolevels = 10000;

        wrap = false;
        virtualedit = "block";

        number = true;
        relativenumber = true;
        jumpoptions = "view";

        expandtab = true;
        tabstop = 2;
        shiftround = true;
        shiftwidth = 2;

        termguicolors = true;
        cursorline = true;
        smoothscroll = true;

        ignorecase = true;
        smartcase = true;
        smartindent = true;

        conceallevel = 2;
      };

      clipboard.register = "unnamedplus";
      globals.mapleader = " ";

      lsp.servers.copilot.enable = true;

      plugins.sidekick = {
        enable = true;
        settings.cli.tools.pi.cmd = ["pi" "--continue"];
      };

      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<C-s>";
          __unkeyed-2 = "<cmd>w<cr><esc>";
          mode = ["i" "x" "n" "s"];
          desc = "Save file";
          silent = false;
        }
        {
          __unkeyed-1 = "<esc>";
          __unkeyed-2 = "<cmd>noh<cr><esc>";
          mode = ["i" "n" "s"];
          desc = "Escape and clear search highlight";
          silent = false;
        }
        {
          __unkeyed-1 = "<C-a>";
          __unkeyed-2.__raw = ''function() require("sidekick").nes_jump_or_apply() end'';
          desc = "Next Edit Suggestion";
          icon = {
            icon = "";
            color = "green";
          };
        }
        {
          __unkeyed-1 = "<C-.>";
          __unkeyed-2.__raw = ''function() require("sidekick.cli").focus({ name = "pi" }) end'';
          mode = ["n" "t" "i" "x"];
          desc = "Focus Sidekick";
          icon = {
            icon = "";
            color = "blue";
          };
        }
        {
          __unkeyed-1 = "<leader>a";
          group = "AI";
          icon = {
            icon = "";
            color = "purple";
          };
        }
        {
          __unkeyed-1 = "<leader>aa";
          __unkeyed-2.__raw = ''function() require("sidekick.cli").toggle({ name = "pi", focus = true }) end'';
          desc = "Toggle";
          icon = {
            icon = "";
            color = "green";
          };
        }
        {
          __unkeyed-1 = "<leader>ad";
          __unkeyed-2.__raw = ''function() require("sidekick.cli").close() end'';
          desc = "Close";
          icon = {
            icon = "󰅙";
            color = "red";
          };
        }
        {
          __unkeyed-1 = "<leader>av";
          __unkeyed-2.__raw = ''function() require("sidekick.cli").send({ name = "pi", msg = "{selection}" }) end'';
          mode = ["x"];
          desc = "Send Selection";
          icon = {
            icon = "󰒅";
            color = "cyan";
          };
        }
        {
          __unkeyed-1 = "<leader>af";
          __unkeyed-2.__raw = ''function() require("sidekick.cli").send({ name = "pi", msg = "{file}" }) end'';
          mode = ["x" "n"];
          desc = "Send File";
          icon = {
            icon = "";
            color = "yellow";
          };
        }
      ];
    };
  };
}
