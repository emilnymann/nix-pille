_: {
  flake.nixosModules.media-server = {pkgs, ...}: {
    virtualisation.oci-containers.backend = "podman";

    users.groups.media.gid = 980;

    systemd.tmpfiles.rules = [
      "d /srv/media 2775 root media -"
      "d /srv/media/media 2775 root media -"
      "d /srv/media/media/tv 2775 root media -"
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
