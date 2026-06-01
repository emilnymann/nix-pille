{ self, inputs, ... }:
{
	flake.nixosModules.nvim = { pkgs, lib, ... }: {
		programs.neovim = {
        enable = true;
        defaultEditor = true;
    };
	};

  flake.homeModules.lazyvim = { pkgs, lib, config, ... }:
  let
    neovimWithDeps = pkgs.neovim.override {
      extraMakeWrapperArgs = lib.escapeShellArgs [
        "--suffix" "PATH" ":" (pkgs.lib.makeBinPath (with pkgs; [
          tree-sitter
          ripgrep
          stylua
          ast-grep
          fd
          fzf
          gcc
          unzip
          trash-cli
          imagemagick
          python3
          tectonic
          ghostscript
          mermaid-cli
          sqlite
        ] ++ config.programs.lazyvim.extraPackages ))
        "--set" "SQLITE3_PATH" "${pkgs.sqlite.out}/lib/libsqlite3.so"
      ];
    };
  in 
  {
    options.programs.lazyvim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
      };
    };

    config.packages = [ neovimWithDeps ];
  };
}
