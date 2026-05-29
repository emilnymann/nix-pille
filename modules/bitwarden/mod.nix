{ flake.nixosModules.bitwarden = { pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    bitwarden-desktop
  ];
}; }
