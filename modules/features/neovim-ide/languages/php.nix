_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.lsp.servers.phpantom_lsp = {
      enable = true;
    };

    # PHPantom 0.8 leaves its process alive after Neovim closes. Force-stop
    # it so repeated editor sessions do not accumulate multi-gigabyte orphans.
    programs.nixvim.autoCmd = [
      {
        event = ["VimLeavePre"];
        callback.__raw = ''
          function()
            for _, client in ipairs(vim.lsp.get_clients({name = "phpantom_lsp"})) do
              client:stop(true)
            end
          end
        '';
      }
    ];
  };
}
