_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.plugins.conform-nvim = {
      enable = true;
      autoInstall.enable = true;

      settings = {
        default_format_opts.lsp_format = "fallback";
        format_on_save.timeout_ms = 1000;
      };
    };
  };
}
