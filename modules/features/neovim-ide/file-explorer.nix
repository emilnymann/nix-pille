_: {
  flake.homeModules.neovim-ide = {pkgs, ...}: {
    programs.nixvim = {
      extraPackages = with pkgs; [fd];
      plugins = {
        snacks = {
          enable = true;
          settings = {
            explorer = {
              enabled = true;
            };
          };
        };
      };

      keymaps = [
        {
          mode = ["n"];
          key = "<leader>e";
          action.__raw = "function() Snacks.explorer() end";
          options = {
            desc = "File explorer";
          };
        }
      ];
    };
  };
}
