_: {
  flake.nixosModules.media-server = {config, ...}: {
    virtualisation.oci-containers.containers.emby = {
      image = "lscr.io/linuxserver/emby:latest";
      environment = {
        PUID = toString config.users.users.emby.uid;
        PGID = toString config.users.groups.media.gid;
        UMASK = "002";
        TZ = "Europe/Copenhagen";
      };
      networks = ["media"];
      volumes = [
        "/srv/media:/data"
        "emby-config:/config"
      ];
      devices = ["/dev/dri:/dev/dri"];
    };

    systemd.services."podman-emby" = {
      requires = ["podman-network-media-create.service"];
      after = ["podman-network-media-create.service"];
    };

    features.media-server.caddy.virtualHosts."emby.emns.dev" = ''
      reverse_proxy emby:8096
    '';
  };
}
