{inputs, ...}: {
  flake.homeModules.neovim-ide = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.nixvim.homeModules.nixvim];

    # create nvim cache dir on home-manager activation, after
    # DAG (directed acyclic graph) write boundary, so after HM finishes
    # writing managed files and symlinks.
    home.activation.createNvimCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "${config.xdg.cacheHome}/nvim"
    '';

    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      nixpkgs.config.allowUnfree = true;

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

      globals = {
        mapleader = " ";
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
      ];
    };
  };
}
