_: {
  flake.nixosModules.media-server = {
    lib,
    config,
    ...
  }: {
    systemd.tmpfiles.rules = [
      "d /srv/media/media/tv 2775 root media -"
      "d /srv/media/media/tv-uhd 2775 root media -"
    ];

    sops = {
      secrets = {
        "sonarr/api-key".restartUnits = ["podman-sonarr.service" "podman-sonarr-uhd.service"];
      };

      templates = {
        "sonarr/env" = {
          owner = "sonarr";
          restartUnits = ["podman-sonarr.service"];
          content = lib.generators.toKeyValue {} {
            SONARR__AUTH__APIKEY = config.sops.placeholder."sonarr/api-key";
          };
        };

        "sonarr-uhd/env" = {
          owner = "sonarr";
          restartUnits = ["podman-sonarr-uhd.service"];
          content = lib.generators.toKeyValue {} {
            SONARR__AUTH__APIKEY = config.sops.placeholder."sonarr/api-key";
          };
        };
      };
    };

    virtualisation.oci-containers.containers = {
      sonarr = {
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

      sonarr-uhd = {
        image = "ghcr.io/hotio/sonarr:release";
        environment = {
          PUID = toString config.users.users.sonarr.uid;
          PGID = toString config.users.groups.media.gid;
          UMASK = "002";
          TZ = "Europe/Copenhagen";
          SONARR__SERVER__BINDADDRESS = "0.0.0.0";
          SONARR__SERVER__PORT = "8989";
        };
        environmentFiles = [config.sops.templates."sonarr-uhd/env".path];
        networks = ["media"];
        volumes = [
          "/srv/media:/data"
          "sonarr-uhd-config:/config"
        ];
      };
    };

    systemd.services = {
      "podman-sonarr" = {
        requires = ["podman-network-media-create.service"];
        after = ["podman-network-media-create.service"];
      };

      "podman-sonarr-uhd" = {
        requires = ["podman-network-media-create.service"];
        after = ["podman-network-media-create.service"];
      };
    };

    features.media-server.configarr.parts.sonarr.instance1 = {
      include = [
        {
          # TRASH quality defs
          template = "bef99584217af744e404ed44a33af589";
          source = "TRASH";
        }
      ];
      base_url = "http://sonarr:8989";
      api_key = config.sops.placeholder."sonarr/api-key";
      delete_unmanaged_custom_formats.enabled = true;
      delete_unmanaged_quality_profiles.enabled = true;
      root_folders = ["/data/media/tv"];

      media_naming = {
        series = "emby-tvdb";
        season = "default";
        episodes = {
          rename = true;
          standard = "default";
          daily = "default";
          anime = "default";
        };
      };

      quality_profiles = [
        {
          name = "HD";
          reset_unmatched_scores.enabled = true;
          upgrade = {
            allowed = true;
            until_quality = "WEB 1080p";
            until_score = 1000;
            min_format_score = 5;
          };
          min_format_score = 0;
          quality_sort = "top";
          qualities = [
            {
              name = "Bluray-1080p Remux";
            }
            {
              name = "WEB 1080p";
              qualities = ["WEBDL-1080p" "WEBRip-1080p"];
            }
            {
              name = "Bluray-1080p";
            }
            {
              name = "HDTV-1080p";
            }
            {
              name = "WEB 720p";
              qualities = ["WEBDL-720p" "WEBRip-720p"];
            }
            {
              name = "Bluray-720p";
            }
            {
              name = "HDTV-720p";
            }
          ];
        }
      ];

      custom_formats = [
        {
          trash_ids = [
            # Unwanted
            "15a05bc7c1a36e2b57fd628f8977e2fc" # AV1
            "32b367365729d530ca1c124a0b180c64" # Bad Dual Groups
            "85c61753df5da1fb2aab6f2a47426b09" # BR-DISK
            "9c11cd3f07101cdba90a2d81cf0e56b4" # LQ
            "82d40da2bc6923f41e14394075dd4b03" # No-RlsGroup
            "23297a736ca77c0fc8e70f8edd7ee56c" # Upscaled

            # Language
            "ae575f95ab639ba5d15f663bf019e3e8" # Original only

            # High-qual groups
            "9965a052eb87b0d10313b1cea89eb451" # RMX T1
            "8a1d0c3d7497e741736761a1da866a2e" # RMX T2
            "d6819cba26b1a6508138d25fb5e32293" # HD BR T1
            "c2216b7b8aa545dc1ce8388c618f8d57" # HD BR T2
            "e6258996055b9fbab7e9cb2f75819294" # WEB T1
            "58790d4e2fdcd9733aa7ae68ba2bb503" # WEB T2
            "d84935abd3f8556dcd51d4f27e22d0a6" # WEB T3
          ];
          assign_scores_to = [
            {name = "HD";}
          ];
        }
      ];

      custom_format_groups = [
        {
          trash_guide = [
            {
              # Repack/Proper
              id = "22256473b656e195eabc2798e326fbb7";
              include_unrequired = true;
            }
            {
              # Audio Formats
              id = "e9a1944a254e6f8a9da63083f7ae15cb";
              include_unrequired = true;
            }
            {
              # Audio Channels
              id = "42b39185048c0a3e852270ced3076284";
              include_unrequired = true;
            }
            {
              # Streaming Services
              id = "abe720fab2d27682adc2a735136cec02";
              include_unrequired = true;
            }
          ];
        }
      ];

      delay_profiles.default = {
        enableUsenet = true;
        enableTorrent = false;
        preferredProtocol = "usenet";
        usenetDelay = 10;
        torrentDelay = 0;
        bypassIfHighestQuality = false;
        bypassIfAboveCustomFormatScore = false;
        minimumCustomFormatScore = 0;
      };

      download_clients = {
        data = [
          {
            name = "NzbDav";
            type = "sabnzbd";
            enable = true;
            priority = 1;
            remove_completed_downloads = true;
            remove_failed_downloads = true;
            fields = {
              host = "nzbdav";
              port = 3000;
              use_ssl = false;
              url_base = "/";
              api_key = config.sops.placeholder."nzbdav/api-key";
              tv_category = "tv";
            };
          }
        ];
        delete_unmanaged.enabled = true;
        config.enable_completed_download_handling = true;
      };
    };

    features.media-server.configarr.parts.sonarr.instance2 = {
      include = [
        {
          # TRASH quality defs
          template = "bef99584217af744e404ed44a33af589";
          source = "TRASH";
        }
      ];
      base_url = "http://sonarr-uhd:8989";
      api_key = config.sops.placeholder."sonarr/api-key";
      delete_unmanaged_custom_formats.enabled = true;
      delete_unmanaged_quality_profiles.enabled = true;
      root_folders = ["/data/media/tv-uhd"];

      media_naming = {
        series = "emby-tvdb";
        season = "default";
        episodes = {
          rename = true;
          standard = "default";
          daily = "default";
          anime = "default";
        };
      };

      quality_profiles = [
        {
          name = "UHD";
          reset_unmatched_scores.enabled = true;
          upgrade = {
            allowed = true;
            until_quality = "WEB 2160p";
            until_score = 1000;
            min_format_score = 5;
          };
          min_format_score = 0;
          quality_sort = "top";
          qualities = [
            {
              name = "Bluray-2160p Remux";
            }
            {
              name = "Bluray-2160p";
            }
            {
              name = "WEB 2160p";
              qualities = ["WEBDL-2160p" "WEBRip-2160p"];
            }
            {
              name = "HDTV-2160p";
            }
          ];
        }
      ];

      custom_formats = [
        {
          trash_ids = [
            # UHD / HDR
            "1bef6c151fa35093015b0bfef18279e5" # 2160p
            "505d871304820ba7106b693be6fe4a9e" # HDR
            "7c3a61a9c6cb04f52f1544be6d44a026" # DV Boost
            "9b27ab6498ec0f31a3353992e19434ca" # DV (w/o HDR fallback)
            "0c4b99df9206d2cfac3c05ab897dd62a" # HDR10+ Boost

            # Unwanted
            "15a05bc7c1a36e2b57fd628f8977e2fc" # AV1
            "32b367365729d530ca1c124a0b180c64" # Bad Dual Groups
            "85c61753df5da1fb2aab6f2a47426b09" # BR-DISK
            "9c11cd3f07101cdba90a2d81cf0e56b4" # LQ
            "82d40da2bc6923f41e14394075dd4b03" # No-RlsGroup
            "23297a736ca77c0fc8e70f8edd7ee56c" # Upscaled

            # Language
            "ae575f95ab639ba5d15f663bf019e3e8" # Original only

            # High-qual groups
            "9965a052eb87b0d10313b1cea89eb451" # RMX T1
            "8a1d0c3d7497e741736761a1da866a2e" # RMX T2
            "d6819cba26b1a6508138d25fb5e32293" # HD BR T1
            "c2216b7b8aa545dc1ce8388c618f8d57" # HD BR T2
            "e6258996055b9fbab7e9cb2f75819294" # WEB T1
            "58790d4e2fdcd9733aa7ae68ba2bb503" # WEB T2
            "d84935abd3f8556dcd51d4f27e22d0a6" # WEB T3
          ];
          assign_scores_to = [
            {name = "UHD";}
          ];
        }
      ];

      custom_format_groups = [
        {
          trash_guide = [
            {
              # Repack/Proper
              id = "22256473b656e195eabc2798e326fbb7";
              include_unrequired = true;
            }
            {
              # Audio Formats
              id = "e9a1944a254e6f8a9da63083f7ae15cb";
              include_unrequired = true;
            }
            {
              # Audio Channels
              id = "42b39185048c0a3e852270ced3076284";
              include_unrequired = true;
            }
            {
              # Streaming Services
              id = "abe720fab2d27682adc2a735136cec02";
              include_unrequired = true;
            }
          ];
        }
      ];

      delay_profiles.default = {
        enableUsenet = true;
        enableTorrent = false;
        preferredProtocol = "usenet";
        usenetDelay = 10;
        torrentDelay = 0;
        bypassIfHighestQuality = false;
        bypassIfAboveCustomFormatScore = false;
        minimumCustomFormatScore = 0;
      };

      download_clients = {
        data = [
          {
            name = "NzbDav";
            type = "sabnzbd";
            enable = true;
            priority = 1;
            remove_completed_downloads = true;
            remove_failed_downloads = true;
            fields = {
              host = "nzbdav";
              port = 3000;
              use_ssl = false;
              url_base = "/";
              api_key = config.sops.placeholder."nzbdav/api-key";
              tv_category = "tv-uhd";
            };
          }
        ];
        delete_unmanaged.enabled = true;
        config.enable_completed_download_handling = true;
      };
    };

    features.media-server.caddy.virtualHosts = {
      "sonarr.emns.dev" = ''
        reverse_proxy sonarr:8989
      '';

      "uhd.sonarr.emns.dev" = ''
        reverse_proxy sonarr-uhd:8989
      '';
    };
  };
}
