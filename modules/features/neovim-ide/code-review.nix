_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.tuicr = {
        enable = true;
      };

      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>d";
          group = "Diff";
        }
      ];

      keymaps = [
        {
          mode = ["n"];
          key = "<leader>dR";
          action = "<cmd>Tuicr<cr>";
          options = {
            desc = "Review";
          };
        }
      ];
    };
  };
}
