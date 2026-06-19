_: {
  flake.nixosModules.media-server = {config, ...}: {
    virtualisation.oci-containers.containers.seerr = {
      image = "ghcr.io/hotio/seerr:release-v3";
      environment = {
        PUID = toString config.users.users.seerr.uid;
        PGID = toString config.users.groups.media.gid;
        UMASK = "002";
        TZ = "Europe/Copenhagen";
      };
      networks = ["media"];
      volumes = [
        "seerr-config:/config"
      ];
    };

    systemd.services."podman-seerr" = {
      requires = ["podman-network-media-create.service"];
      after = ["podman-network-media-create.service"];
    };

    features.media-server.caddy.virtualHosts."request.emns.dev" = ''
      reverse_proxy seerr:5055
    '';
  };
}
