_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "enter";
          };
          # Use Neovim's native vim.snippet implementation. This expands both
          # LSP-provided snippets and the local snippets source below without
          # pulling in friendly-snippets (or another snippet engine).
          snippets = {
            preset = "default";
            expand.__raw = ''function(snippet) vim.snippet.expand(snippet) end'';
          };
          sources = {
            default = ["lsp" "path" "snippets" "buffer"];
            providers.snippets = {
              # Use blink's built-in file-backed source, but do not scan
              # friendly-snippets or any other external snippet collection.
              opts.friendly_snippets = false;
            };
          };
        };
      };
    };
  };
}
