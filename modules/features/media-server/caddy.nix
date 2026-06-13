_: {
  flake.nixosModules.media-server = {
    services.caddy = {
      enable = true;
      openFirewall = true;
    };
  };
}
