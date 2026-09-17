_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        blink-cmp = {
          enable = true;
          settings = {
            keymap = {
              preset = "enter";
            };
            snippets = {
              preset = "default";
              expand.__raw = ''function(snippet) vim.snippet.expand(snippet) end'';
            };
            sources = {
              default = ["lsp" "path" "snippets" "buffer"];
            };
          };
        };
        friendly-snippets = {
          enable = true;
        };
      };
    };
  };
}
