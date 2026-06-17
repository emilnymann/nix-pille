_: {
  flake.nixosModules.media-server = {
    pkgs,
    config,
    lib,
    ...
  }: let
    cfg = config.features.media-server.configarr;
    serviceNames = [
      "sonarr"
      "radarr"
      "whisparr"
      "readarr"
      "lidarr"
    ];
    generatedConfig =
      (lib.listToAttrs (map (name: {
          name = "${name}Enabled";
          value = (cfg.parts.${name} or {}) != {};
        })
        serviceNames))
      // cfg.parts;
  in {
    options.features.media-server.configarr.parts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      default = {};
      description = ''
        Configarr service configuration fragments contributed by media-server
        submodules. The Configarr module compiles these fragments into the
        final config.yml sops template.
      '';
    };

    config = {
      users.users.configarr = {
        isSystemUser = true;
        uid = 983;
        group = "media";
      };

      sops.templates."configarr/config.yml" = {
        owner = "configarr";
        file = (pkgs.formats.yaml {}).generate "configarr-config.yml" generatedConfig;
      };

      virtualisation.oci-containers.containers.configarr = {
        image = "ghcr.io/raydak-labs/configarr:1";
        autoStart = false;
        user = "${toString config.users.users.configarr.uid}:${toString config.users.groups.media.gid}";
        environment = {
          TZ = "Europe/Copenhagen";
        };
        networks = ["media"];
        volumes = [
          "configarr-config:/app/config"
          "configarr-repos:/app/repos"
          "${config.sops.templates."configarr/config.yml".path}:/app/config/config.yml:ro"
        ];
      };

      systemd.services."podman-configarr" = {
        requires = ["podman-network-media-create.service"];
        after = ["podman-network-media-create.service"];
      };
    };
  };
}
