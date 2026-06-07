_: {
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
  ];
}
