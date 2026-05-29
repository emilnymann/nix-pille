{ flake.nixosModules.gpg = { pkgs, ... }: {
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}; }
