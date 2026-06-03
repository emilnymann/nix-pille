_: {
  flake.homeModules.neovim-ide =
    { pkgs, ... }:
    {
      programs.nixvim = {
        enable = true;
        defaultEditor = true;

        clipboard.register = "unnamedplus";
        clipboard.colorschemes.gruvbox-material = {
          enable = true;
          autoLoad = true;
        };

        opts = {
          wrap = false;
          number = true;
          relativenumber = true;
          expandtab = true;
          tabstop = 2;
          shiftwidth = 2;
          exrc = true;
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
      };
    };
}
