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
  ];
}
