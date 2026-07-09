_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.lsp = {
      servers = {
        lua_ls = {
          enable = true;
        };
      };
    };
  };
}
