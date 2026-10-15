_: {
  flake.nixosModules.nix-helper = _: {
    programs.nh = {
      enable = true;
    };
  };
}
