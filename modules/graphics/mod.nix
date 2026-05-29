{ flake.nixosModules.graphics = { ... }: {
  hardware.graphics.enable = true;
  hardware.enableRedistributableFirmware = true;
}; }
