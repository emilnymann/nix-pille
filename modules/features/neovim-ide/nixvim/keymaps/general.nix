_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.keymaps = [
      {
        mode = [
          "i"
          "n"
          "s"
        ];
        key = "<esc>";
        action = "<cmd>noh<cr><esc>";
        options = {
          desc = "Escape and clear search highlight";
        };
      }
      {
        mode = [
          "i"
          "x"
          "n"
          "s"
        ];
        key = "<C-s>";
        action = "<cmd>w<cr><esc>";
        options = {
          desc = "Save file";
        };
      }
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
