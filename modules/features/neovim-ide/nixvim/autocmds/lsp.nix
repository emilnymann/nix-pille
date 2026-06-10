_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.autoCmd = [
      {
        event = [ "BufWritePre" ];
        callback.__raw = "function() vim.lsp.buf.format() end";
      }
    ];
  };
}
