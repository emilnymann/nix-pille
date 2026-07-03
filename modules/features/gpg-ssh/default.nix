_: {
  flake.nixosModules.gpg-ssh = _: {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      settings = {
        default-cache-ttl = 1800;
      };
    };
  };

  flake.darwinModules.gpg-ssh = _: {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
