_: {
  flake.homeModules.neovim-ide = {pkgs, ...}: {
    programs.nixvim = {
      plugins.conform-nvim.settings.formatters_by_ft.nix = ["alejandra"];

      lsp.servers = {
        nixd = {
          enable = true;
          package = pkgs.nixd;
          config = {
            cmd = ["nixd"];
            filetypes = ["nix"];
            root_markers = [
              "flake.nix"
              ".git"
            ];
          };
        };
      };
    };
  };
}
