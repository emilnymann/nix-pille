_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.keymaps = [
      {
        mode = ["n"];
        key = "<C-h>";
        action = "<C-w>h";
        options = {desc = "Go to left window";};
      }
      {
        mode = ["n"];
        key = "<C-j>";
        action = "<C-w>j";
        options = {desc = "Go to lower window";};
      }
      {
        mode = ["n"];
        key = "<C-k>";
        action = "<C-w>k";
        options = {desc = "Go to upper window";};
      }
      {
        mode = ["n"];
        key = "<C-l>";
        action = "<C-w>l";
        options = {desc = "Go to right window";};
      }
    ];
  };
}
