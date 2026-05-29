{ flake.nixosModules.bitwarden = { pkgs, ... }: {
  environment.systemPackages = [
    pkgs.wl-clipboard
    pkgs.bitwarden-desktop
  ];
}; }
