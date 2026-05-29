{ flake.nixosModules.discord = { pkgs, ... }: {
  environment.systemPackages = [
    pkgs.mako
    pkgs.discord
  ];
}; }
