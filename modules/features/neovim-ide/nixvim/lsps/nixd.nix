_: {
  flake.homeModules.neovim-ide =
    { pkgs, ... }:
    {
      programs.nixvim.lsp = {
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
    };
}
