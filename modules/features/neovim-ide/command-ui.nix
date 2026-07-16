_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.plugins.noice.enable = true;
  };
}
