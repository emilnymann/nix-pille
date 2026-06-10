_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "enter";
          };
        };
      };
    };
  };
}
