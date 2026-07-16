_: {
  flake.homeModules.neovim-ide = {pkgs, ...}: {
    programs.nixvim = {
      extraPackages = with pkgs; [
        neovim-remote
      ];

      plugins = {
        which-key = {
          enable = true;
          settings.spec = [
            {
              __unkeyed-1 = "<leader>g";
              group = "Git";
            }
          ];
        };

        snacks = {
        enable = true;
        settings = {
          picker = {
            enabled = true;
          };
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
        {
          mode = ["n"];
          key = "<leader>gb";
          action.__raw = "function() Snacks.picker.git_log_line() end";
          options = {
            desc = "Git blame line";
          };
        }
        {
          mode = ["n"];
          key = "<leader>gf";
          action.__raw = "function() Snacks.picker.git_log_file() end";
          options = {
            desc = "Git file history";
          };
        }
      ];
    };
  };
}
