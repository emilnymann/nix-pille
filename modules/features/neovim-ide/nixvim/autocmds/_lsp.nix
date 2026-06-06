_: {
  programs.nixvim.autoCmd = [
    {
      event = [ "BufWritePre" ];
      callback.__raw = "function() vim.lsp.buf.format() end";
    }
  ];
}
