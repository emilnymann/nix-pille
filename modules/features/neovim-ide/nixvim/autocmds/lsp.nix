_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.autoCmd = [
      {
        event = [ "BufWritePre" ];
        callback.__raw = ''
          function(args)
            local bufname = vim.api.nvim_buf_get_name(args.buf)
            if bufname == "" then
              return
            end

            local dir = vim.fs.dirname(bufname)
            local marker = vim.fs.find(".format-on-save", {
              path = dir,
              upward = true,
            })[1]

            if not marker then
              return
            end

            vim.lsp.buf.format({ bufnr = args.buf, async = false })
          end
        '';
      }
    ];
  };
}
