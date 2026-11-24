_: {
  flake.homeModules.janeski = _: {
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
      ];
    };
  };
}
