_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.friendly-snippets = {
        enable = true;
      };
    };
  };
}
