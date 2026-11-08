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
                if vim.b[event.buf].which_key_svelte_mapping then
                  return
                end

                require("which-key").add({
                  {
                    "<",
                    "<",
                    mode = "i",
                    buffer = event.buf,
                    noremap = true,
                    silent = false,
                    desc = "Insert < without auto-pairing in Svelte",
                  },
                })
                vim.b[event.buf].which_key_svelte_mapping = true
              end
            '';
          }
        ];
      };
    };
  };
}
