{ flake.nixosModules.nvim = { ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}; }
