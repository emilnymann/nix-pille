_: {
  flake.homeModules.neovim-ide =
    { lib, config, ... }:
    let
      withSnacks = config.programs.nixvim.plugins.snacks.enable;
    in
    {
      programs.nixvim.keymaps = [
        {
          mode = [
            "n"
          ];
          key = "<S-h>";
          action = "<cmd>bprevious<cr>";
          options = {
            desc = "Previous buffer";
          };
        }
        {
          mode = [
            "n"
          ];
          key = "<S-l>";
          action = "<cmd>bnext<cr>";
          options = {
            desc = "Next buffer";
          };
        }
      ]
      ++ lib.optionals withSnacks [
        {
          mode = [
            "n"
          ];
          key = "<leader>bd";
          action.__raw = "function() Snacks.bufdelete() end";
          options = {
            desc = "Delete buffer";
          };
        }
        {
          mode = [
            "n"
          ];
          key = "<leader>bo";
          action.__raw = "function() Snacks.bufdelete.other() end";
          options = {
            desc = "Delete other buffers";
          };
        }
      ];
    };
}
