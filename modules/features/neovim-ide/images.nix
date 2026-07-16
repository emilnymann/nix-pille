_: {
  flake.homeModules.neovim-ide = {pkgs, ...}: {
    programs.nixvim = {
      extraPackages = with pkgs; [ghostscript tectonic mermaid-cli];
      dependencies.imagemagick.enable = true;

      plugins = {
        snacks = {
          enable = true;
          settings = {
            image = {
              enabled = true;
            };
          };
        };
      };
    };
  };
}
