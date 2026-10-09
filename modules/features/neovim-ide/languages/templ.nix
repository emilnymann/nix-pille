_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            templ = {
              enable = true;
            };
            html = {
              enable = true;
              config = {
                filetypes = ["templ" "html"];
              };
            };
          };
        };
      };
    };
  };
}
