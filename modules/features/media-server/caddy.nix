_: {
  flake.nixosModules.media-server = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.features.media-server.caddy.virtualHosts = lib.mkOption {
      type = lib.types.attrsOf lib.types.lines;
      default = {};
      description = ''
        Virtual host blocks for the Caddy container. Each attribute name is a
        hostname; the value is the body of the Caddy site block. Other modules
        in this feature set add to this option to register themselves.
      '';
      example = lib.literalExpression ''
        { "sabnzbd.example.com" = "reverse_proxy sabnzbd:8080"; }
      '';
    };

    config = let
      caddyfile = pkgs.writeText "Caddyfile" (
        lib.concatStringsSep "\n" (
          lib.mapAttrsToList (host: body: ''
            ${host} {
              ${body}
            }
          '')
          config.features.media-server.caddy.virtualHosts
        )
      );
    in {
      systemd.services."podman-caddy" = {
        requires = ["podman-network-media-create.service"];
        after = ["podman-network-media-create.service"];
      };

      virtualisation.oci-containers.containers.caddy = {
        image = "caddy:2";
        networks = ["media"];
        ports = ["80:80" "443:443" "443:443/udp"];
        volumes = [
          "caddy-config:/config"
          "caddy-data:/data"
          "${caddyfile}:/etc/caddy/Caddyfile:ro"
        ];
      };
    };
  };
}
