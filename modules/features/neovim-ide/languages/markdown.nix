_: {
  flake.homeModules.neovim-ide = _: {
    programs = {
      nixvim = {
        lsp = {
          servers = {
            marksman = {
              enable = true;
            };
          };
        };

        plugins = {
          render-markdown = {
            enable = true;
            settings = {
              code = {
                disable = ["mermaid"];
              };
            };
          };
        };
      };
    };
  };
}
