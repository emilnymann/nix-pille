{ flake.nixosModules.yazi = { pkgs, ... }: {
  programs.yazi = {
    enable = true;
  };
}; }
