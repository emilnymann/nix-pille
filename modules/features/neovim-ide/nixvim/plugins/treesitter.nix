_: {
  flake.homeModules.neovim-ide = {pkgs, ...}: {
    programs.nixvim = {
      extraPackages = with pkgs; [tree-sitter];
      plugins.treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
      };
    };
  };
}
