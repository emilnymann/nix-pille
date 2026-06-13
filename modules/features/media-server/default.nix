_: {
  flake.nixosModules.media-server = {
    imports = [./_container-shared.nix];

    systemd.tmpfiles.rules = [
      "d /var/lib/media      0755 root media - -"
      "d /var/lib/media/data 2775 root media - -"
    ];

    systemd.network = {
      netdevs."20-br-media".netdevConfig = {
        Name = "br-media";
        Kind = "bridge";
      };
      networks."20-br-media" = {
        matchConfig.Name = "br-media";
        networkConfig = {
          Address = "10.100.0.1/24";
          ConfigureWithoutCarrier = true;
          DNS = "10.100.0.1";
          Domains = "~media";
        };
        linkConfig.RequiredForOnline = "no";
      };
    };

    services.dnsmasq = {
      enable = true;
      settings = {
        bind-dynamic = true;
        interface = "br-media";
        dhcp-range = ["10.100.0.10,10.100.0.254,24h"];
        dhcp-authoritative = true;
        domain = "media";
        local = "/media/";
        no-resolv = true;
        server = ["127.0.0.53"];
      };
    };

    networking.firewall.interfaces."br-media" = {
      allowedUDPPorts = [
        53
        67
      ];
      allowedTCPPorts = [53];
    };

    networking.nat = {
      enable = true;
      internalInterfaces = ["br-media"];
    };
  };
}
