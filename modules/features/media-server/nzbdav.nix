_: {
  flake.nixosModules.media-server = {config, ...}: {
    systemd.tmpfiles.rules = [
      "d /srv/media/nzbdav 2775 nzbdav media -"
      "d /srv/media/nzbdav/completed 2775 nzbdav media -"
    ];

    sops = {
      secrets = {
        "nzbdav/api-key".restartUnits = ["podman-nzbdav.service"];
      };
    };

    virtualisation.oci-containers.containers.nzbdav = {
      image = "ghcr.io/nzbdav-dev/nzbdav:0.6.x";
      environment = {
        PUID = toString config.users.users.nzbdav.uid;
        PGID = toString config.users.groups.media.gid;
        UMASK = "002";
        TZ = "Europe/Copenhagen";
      };
      networks = ["media"];
      volumes = [
        "/srv/media:/data"
        "nzbdav-config:/config"
      ];
      extraOptions = ["--umask=0002"];
    };

    systemd.services."podman-nzbdav" = {
      requires = ["podman-network-media-create.service"];
      after = ["podman-network-media-create.service"];
    };

    features.media-server.caddy.virtualHosts."nzbdav.emns.dev" = ''
      reverse_proxy nzbdav:3000
    '';
  };
}
