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

      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>e";
          __unkeyed-2.__raw = "function() Snacks.explorer() end";
          desc = "File explorer";
          silent = false;
        }
      ];
    };
  };
}
