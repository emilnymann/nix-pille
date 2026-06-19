_: {
  flake.nixosModules.media-server = {pkgs, ...}: {
    virtualisation.oci-containers.backend = "podman";

    users.groups.media.gid = 980;
    users.users = {
      nzbget = {
        isSystemUser = true;
        group = "media";
        uid = 981;
      };

      sonarr = {
        isSystemUser = true;
        group = "media";
        uid = 982;
      };

      configarr = {
        isSystemUser = true;
        group = "media";
        uid = 983;
      };

      radarr = {
        isSystemUser = true;
        group = "media";
        uid = 984;
      };

      nzbdav = {
        isSystemUser = true;
        group = "media";
        uid = 985;
      };

      emby = {
        isSystemUser = true;
        group = "media";
        uid = 986;
      };

      seerr = {
        isSystemUser = true;
        group = "media";
        uid = 987;
      };
    };

    systemd.tmpfiles.rules = [
      "d /srv/media 2775 root media -"
      "d /srv/media/media 2775 root media -"
    ];

    systemd.services."podman-network-media-create" = {
      description = "Create podman 'media' network";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.podman}/bin/podman network create --ignore media";
      };
    };
  };
}
