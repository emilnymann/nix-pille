_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            svelte = {
              enable = true;
            };
          };
        };

        # mini.pairs' global `<` mapping inserts `<>`, which can interfere
        # with Svelte component completion while the tag name is incomplete.
        # Use a buffer-local literal mapping so completion sees only `<`.
        autoCmd = [
          {
            event = ["FileType"];
            pattern = ["svelte"];
            callback.__raw = ''
              function(event)
                vim.keymap.set("i", "<", "<", {
                  buffer = event.buf,
                  noremap = true,
                  desc = "Insert < without auto-pairing in Svelte",
                })
              end
            '';
          }
        ];
      };
    };
  };
}
