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
            {
              __unkeyed-1 = "<leader>gh";
              group = "Git Hunks";
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

        gitsigns = {
          enable = true;
          settings = {
            signs = {
              add = {text = "▎";};
              change = {text = "▎";};
              delete = {text = "";};
              topdelete = {text = "";};
              changedelete = {text = "▎";};
              untracked = {text = "▎";};
            };

            signs_staged = {
              add = {text = "▎";};
              change = {text = "▎";};
              delete = {text = "";};
              topdelete = {text = "";};
              changedelete = {text = "▎";};
            };

            on_attach.__raw = ''
              function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                  vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
                end

                -- stylua: ignore start
                map("n", "]h", function()
                  if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                  else
                    gs.nav_hunk("next")
                  end
                end, "Next Hunk")
                map("n", "[h", function()
                  if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                  else
                    gs.nav_hunk("prev")
                  end
                end, "Prev Hunk")
                map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
                map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
                map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
                map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
              end
            '';
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
