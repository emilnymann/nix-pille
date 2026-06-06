_: {
  flake.homeModules.neovim-ide =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      withLazygit = config.programs.lazygit.enable;
    in
    {
      # create nvim cache dir on home-manager activation, after
      # DAG (directed acyclic graph) write boundary, so after HM finishes
      # writing managed files and symlinks.
      home.activation.createNvimCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "${config.xdg.cacheHome}/nvim"
      '';

      programs.nixvim = {
        enable = true;
        defaultEditor = true;

        extraPackages = with pkgs; [
          neovim-remote
        ];

        clipboard.register = "unnamedplus";
        colorschemes.gruvbox-material = {
          enable = true;
          autoLoad = true;
        };

        opts = {
          exrc = true;
          undolevels = 10000;

          wrap = false;
          virtualedit = "block";

          number = true;
          relativenumber = true;

          expandtab = true;
          tabstop = 2;
          shiftround = true;
          shiftwidth = 2;

          termguicolors = true;
          cursorline = true;
          smoothscroll = true;

          ignorecase = true;
          smartcase = true;
          smartindent = true;
        };

        globals = {
          mapleader = " ";
        };

        lsp = {
          servers = {
            nixd = {
              enable = true;
              package = pkgs.nixd;
              config = {
                cmd = [ "nixd" ];
                filetypes = [ "nix" ];
                root_markers = [
                  "flake.nix"
                  ".git"
                ];
                settings.nixd.formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
              };
            };
          };
        };

        plugins = {
          snacks = {
            enable = true;
            settings = {
              lazygit = lib.mkIf withLazygit {
                enabled = true;
                configure = true;
              };
            };
          };
        };

        autoCmd = [
          {
            event = [ "BufWritePre" ];
            callback.__raw = ''
              		function()
              			vim.lsp.buf.format()
              		end
            '';
          }
        ];

        keymaps = [
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
        ]
        ++ lib.optional withLazygit {
          mode = [ "n" ];
          key = "<leader>gg";
          action.__raw = ''
            function()
              Snacks.lazygit()
            end
          '';
          options = {
            desc = "Lazygit";
          };
        };
      };
    };
}
