{ flake.nixosModules.discord = { pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    mako
    discord
  ];
}; }
