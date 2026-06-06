{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      neovim-remote
    ];

    plugins.snacks = {
      enable = true;
      settings = {
        lazygit = {
          enabled = true;
        };
      };
    };

    keymaps = [
      {
        mode = [ "n" ];
        key = "<leader>gg";
        action.__raw = "function() Snacks.lazygit() end";
        options = {
          desc = "Git";
        };
      }
    ];
  };
}
