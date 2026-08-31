_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.plugins.noice.enable = true;
    programs.nixvim.plugins.snacks.settings.notifier.enabled = true;
  };
}
