_: {
  flake.homeModules.neovim-ide = {
    config,
    lib,
    ...
  }: {
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
      };

      clipboard.register = "unnamedplus";

      globals = {
        mapleader = " ";
      };
    };
  };
}
