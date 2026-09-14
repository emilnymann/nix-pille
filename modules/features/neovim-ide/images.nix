_: {
  flake.homeModules.neovim-ide = {pkgs, ...}: {
    programs.nixvim = {
      # Zellij 0.45+ supports Kitty graphics, but Snacks still marks it unsupported.
      extraConfigLuaPre = ''
        if vim.env.ZELLIJ ~= nil then
          vim.env.SNACKS_ZELLIJ = "false"
          vim.env.SNACKS_GHOSTTY = "true"
        end
      '';

      extraPackages = with pkgs; [ghostscript tectonic mermaid-cli];
      dependencies.imagemagick.enable = true;

      plugins = {
        snacks = {
          enable = true;
          settings = {
            image = {
              enabled = true;
              doc = {
                enabled = true;
                inline = true;
              };
            };
          };
        };
      };
    };
  };
}
