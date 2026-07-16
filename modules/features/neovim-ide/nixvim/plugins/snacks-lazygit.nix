_: {
  flake.homeModules.neovim-ide = {pkgs, ...}: {
    programs.nixvim = {
      extraPackages = with pkgs; [
        neovim-remote
      ];

      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
        }
      ];

      plugins.snacks = {
        enable = true;
        settings = {
          lazygit = {
            enabled = true;
            config = {
              os = {
                edit = ''sh -c 'if [ -z "$NVIM" ]; then nvim -- "$1"; else nvr --remote-send q && nvr --remote "$1"; fi' sh {{filename}}'';
                editAtLine = ''sh -c 'if [ -z "$NVIM" ]; then nvim +"$1" -- "$2"; else nvr --remote-send q && nvr --remote +"$1" "$2"; fi' sh {{line}} {{filename}}'';
                openDirInEditor = ''sh -c 'if [ -z "$NVIM" ]; then nvim -- "$1"; else nvr --remote-send q && nvr --remote "$1"; fi' sh {{dir}}'';
              };
            };
          };
        };
      };

      keymaps = [
        {
          mode = ["n"];
          key = "<leader>gg";
          action.__raw = "function() Snacks.lazygit() end";
          options = {
            desc = "Git";
          };
        }
      ];
    };
  };
}
