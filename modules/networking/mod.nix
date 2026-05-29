{ flake.nixosModules.networking = { ... }: {
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };
}; }
