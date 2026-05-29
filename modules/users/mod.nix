{ flake.nixosModules.users = { ... }: {
  users.users.ens = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" ];
  };

  hjem.users.ens = {
    enable = true;
  };
}; }
