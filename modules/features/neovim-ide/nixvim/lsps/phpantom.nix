_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.lsp = {
      servers = {
        phpantom_lsp = {
          enable = true;
          config = {
            cmd = ["phpantom_lsp"];
            filetypes = ["php"];
            root_markers = [
              "composer.json"
              ".git"
              ".phpantom.toml"
            ];
          };
        };
      };
    };
  };
}
