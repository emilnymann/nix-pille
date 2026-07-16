_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.lsp.servers.phpantom_lsp.enable = true;
  };
}
