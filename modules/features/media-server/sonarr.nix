_: {
  flake.nixosModules.media-server = {
    lib,
    config,
    ...
  }: {
    users.users.sonarr = {
      isSystemUser = true;
      group = config.users.groups.media.name;
      uid = 982;
    };

    systemd.tmpfiles.rules = [
      "d /srv/media/media 2775 root media -"
      "d /srv/media/media/tv 2775 root media -"
    ];

    sops = {
      secrets = {
        "sonarr/api-key".restartUnits = ["podman-sonarr.service"];
      };

      templates = {
        "sonarr/env" = {
          owner = "sonarr";
          restartUnits = ["podman-sonarr.service"];
          content = lib.generators.toKeyValue {} {
            SONARR__AUTH__APIKEY = config.sops.placeholder."sonarr/api-key";
          };
        };
      };
    };

    virtualisation.oci-containers.containers.sonarr = {
      image = "ghcr.io/hotio/sonarr:release";
      environment = {
        PUID = toString config.users.users.sonarr.uid;
        PGID = toString config.users.groups.media.gid;
        UMASK = "002";
        TZ = "Europe/Copenhagen";
        SONARR__SERVER__BINDADDRESS = "0.0.0.0";
        SONARR__SERVER__PORT = "8989";
      };
      environmentFiles = [config.sops.templates."sonarr/env".path];
      networks = ["media"];
      volumes = [
        "/srv/media:/data"
        "sonarr-config:/config"
      ];
    };

    systemd.services."podman-sonarr" = {
      requires = ["podman-network-media-create.service"];
      after = ["podman-network-media-create.service"];
    };

    features.media-server.caddy.virtualHosts."sonarr.emns.dev" = ''
      reverse_proxy sonarr:8989
    '';
  };
}
