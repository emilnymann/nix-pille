{inputs, ...}: {
  flake.nixosModules.media-server = {
    containers.sabnzbd = {
      autoStart = true;

      # Attach to the shared bridge; address/DNS come from dnsmasq via DHCP.
      privateNetwork = true;
      hostBridge = "br-media";

      bindMounts = {
        # Shared data tree from the host.
        "/data" = {
          hostPath = "/var/lib/media/data";
          isReadOnly = false;
        };
        # age private key for sops (out-of-band on the host, never in repo).
        "/var/lib/sops-age.key" = {
          hostPath = "/var/lib/media-secrets/sabnzbd-age.key";
          isReadOnly = true;
        };
      };

      config = {
        config,
        lib,
        ...
      }: {
        imports = [
          inputs.sops-nix.nixosModules.sops
          ./_container-shared.nix
        ];

        # Decrypt secrets inside the container so ownership matches the
        # container's sabnzbd user. Ciphertext lives in the repo; only the
        # age key is on the host (bind-mounted above).
        sops = {
          defaultSopsFile = ./secrets/sabnzbd.yaml;
          age.keyFile = "/var/lib/sops-age.key";
          secrets."sabnzbd-ini".owner = "sabnzbd";
        };

        # sabnzbd owns its dirs; media group can read/write so sonarr/radarr
        # (also in media group) can pick up completed downloads.
        users.users.sabnzbd.extraGroups = ["media"];
        systemd.tmpfiles.rules = [
          "d /data/sabnzbd            0775 sabnzbd media - -"
          "d /data/sabnzbd/complete   0775 sabnzbd media - -"
          "d /data/sabnzbd/incomplete 0755 sabnzbd media - -"
        ];

        services.sabnzbd = {
          enable = true;
          settings.misc = {
            host = "0.0.0.0"; # reachable from caddy over the bridge
            port = 8080;
            direct_unpack = true;
            download_dir = "/data/sabnzbd/incomplete";
            complete_dir = "/data/sabnzbd/complete";
            local_ranges = "10.100.0.0/24"; # caddy counts as local
            host_whitelist = "sabnzbd.emns.dev"; # allowed Host header
            inet_exposure = 4;
            cache_limit = "16G";
          };
          # Confidential settings (login, api_key, server creds) merged in.
          secretFiles = [config.sops.secrets."sabnzbd-ini".path];
        };

        networking = {
          interfaces.eth0.useDHCP = true; # get address/DNS from dnsmasq
          firewall.allowedTCPPorts = [8080];
          # Use the DHCP-provided resolver, not the host's resolv.conf.
          useHostResolvConf = lib.mkForce false;
        };

        # sabnzbd pulls in unrar (unfree); container has its own nixpkgs.
        nixpkgs.config.allowUnfree = true;

        system.stateVersion = "26.05";
      };
    };

    # Expose through caddy on the host, addressed by its .media name.
    services.caddy.virtualHosts."sabnzbd.emns.dev".extraConfig = ''
      reverse_proxy sabnzbd.media:8080
    '';
  };
}
