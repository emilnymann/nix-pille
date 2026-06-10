_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.autoclose = {
        enable = true;
      };
    };
  };
}
