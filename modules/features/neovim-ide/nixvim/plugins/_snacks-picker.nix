_: {
  programs.nixvim = {
    plugins = {
      snacks = {
        enable = true;
        settings = {
          picker = {
            enabled = true;
          };
        };
      };
    };

    keymaps = [
      {
        mode = [
          "n"
        ];
        key = "<leader><space>";
        action.__raw = "function() Snacks.picker.smart() end";
        options = {
          desc = "Find files";
        };
      }
    ];
  };
}
