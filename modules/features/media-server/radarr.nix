_: {
  flake.nixosModules.media-server = {
    lib,
    config,
    ...
  }: {
    systemd.tmpfiles.rules = [
      "d /srv/media/media/movies 2775 root media -"
      "d /srv/media/media/movies-uhd 2775 root media -"
    ];

    sops = {
      secrets = {
        "radarr/api-key".restartUnits = ["podman-radarr.service" "podman-radarr-uhd.service"];
      };

      templates = {
        "radarr/env" = {
          owner = "radarr";
          restartUnits = ["podman-radarr.service"];
          content = lib.generators.toKeyValue {} {
            RADARR__AUTH__APIKEY = config.sops.placeholder."radarr/api-key";
          };
        };

        "radarr-uhd/env" = {
          owner = "radarr";
          restartUnits = ["podman-radarr-uhd.service"];
          content = lib.generators.toKeyValue {} {
            RADARR__AUTH__APIKEY = config.sops.placeholder."radarr/api-key";
          };
        };
      };
    };

    virtualisation.oci-containers.containers = {
      radarr = {
        image = "ghcr.io/hotio/radarr:release";
        environment = {
          PUID = toString config.users.users.radarr.uid;
          PGID = toString config.users.groups.media.gid;
          UMASK = "002";
          TZ = "Europe/Copenhagen";
          RADARR__SERVER__BINDADDRESS = "0.0.0.0";
          RADARR__SERVER__PORT = "7878";
        };
        environmentFiles = [config.sops.templates."radarr/env".path];
        networks = ["media"];
        volumes = [
          "/srv/media:/data"
          "radarr-config:/config"
        ];
      };

      radarr-uhd = {
        image = "ghcr.io/hotio/radarr:release";
        environment = {
          PUID = toString config.users.users.radarr.uid;
          PGID = toString config.users.groups.media.gid;
          UMASK = "002";
          TZ = "Europe/Copenhagen";
          RADARR__SERVER__BINDADDRESS = "0.0.0.0";
          RADARR__SERVER__PORT = "7878";
        };
        environmentFiles = [config.sops.templates."radarr-uhd/env".path];
        networks = ["media"];
        volumes = [
          "/srv/media:/data"
          "radarr-uhd-config:/config"
        ];
      };
    };

    systemd.services = {
      "podman-radarr" = {
        requires = ["podman-network-media-create.service"];
        after = ["podman-network-media-create.service"];
      };

      "podman-radarr-uhd" = {
        requires = ["podman-network-media-create.service"];
        after = ["podman-network-media-create.service"];
      };
    };

    features.media-server.configarr.parts.radarr.instance1 = {
      include = [
        {
          # TRASH quality defs
          template = "aed34b9f60ee115dfa7918b742336277";
          source = "TRASH";
        }
      ];
      base_url = "http://radarr:7878";
      api_key = config.sops.placeholder."radarr/api-key";
      delete_unmanaged_custom_formats.enabled = true;
      delete_unmanaged_quality_profiles.enabled = true;
      root_folders = ["/data/media/movies"];

      media_naming = {
        folder = "emby-tmdb";
        movie = {
          rename = true;
          standard = "emby-tmdb";
        };
      };

      quality_profiles = [
        {
          name = "HD";
          reset_unmatched_scores.enabled = true;
          upgrade = {
            allowed = true;
            until_quality = "Remux-1080p";
            until_score = 10000;
            min_format_score = 1;
          };
          min_format_score = 0;
          quality_sort = "top";
          qualities = [
            {
              name = "Remux-1080p";
            }
            {
              name = "WEB 1080p";
              qualities = ["WEBDL-1080p" "WEBRip-1080p"];
            }
            {
              name = "WEB 720p";
              qualities = ["WEBDL-720p" "WEBRip-720p"];
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
            "cae4ca30163749b891686f95532519bd" # AV1
            "b6832f586342ef70d9c128d40c07b872" # Dual groups
            "b8cd450cbfa689c0259a01d9e29ba3d6" # 3D
            "ed38b889b31be83fda192888e2286d83" # BR-DISK
            "e6886871085226c3da1830830146846c" # Generated HDR
            "c465ccc73923871b3eb1802042331306" # Line/Mic Dubbed
            "90a6f9a284dff5103f6346090e6280c8" # Low-qual
            "ae9b7c9ebde1f3bd336a8cbd1ec4c5e5" # Stripped group
            "bfd8eb01832d646a0a89c4deb46f8564" # Upscaled

            # Language
            "d6e9318c875905d6cfb5bee961afcea9" # Original only

            # High-qual groups
            "3a3ff47579026e76d6504ebea39390de" # RMX T1
            "9f98181fe5a3fbeb0cc29340da2a468a" # RMX T2
            "8baaf0b3142bf4d94c42a724f034e27a" # RMX T3
            "ed27ebfef2f323e964fb1f61391bcb35" # HD BR T1
            "c20c8647f2746a1f4c4262b0fbbeeeae" # HD BR T2
            "5608c71bcebba0a5e666223bae8c9227" # HD BR T3
            "c20f169ef63c5f40c2def54abaf4438e" # WEB T1
            "403816d65392c79236dcb6dd591aeda4" # WEB T2
            "af94e0fe497124d1f9ce732069ec8c3b" # WEB T3
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
              # Audio Formats
              id = "9d5acd8f1da78dfbae788182f7605200";
              include_unrequired = true;
            }
            {
              # Audio Channels
              id = "71660f8c0900b2de202181efb0ca1c88";
              include_unrequired = true;
            }
            {
              # Repack/Proper
              id = "d688ff99733a9bc626c37eb61ea74704";
              include_unrequired = true;
            }
            {
              # Streaming Services
              id = "d9cc9a504e5ede6294c8b973aad4f028";
              include_unrequired = true;
            }
            {
              # Movie Editions
              id = "f4f1474b963b24cf983455743aa9906c";
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
              api_key = config.sops.placeholder."nzbdav/api-key";
              use_ssl = false;
              url_base = "/";
              movie_category = "movies";
            };
          }
        ];
        delete_unmanaged.enabled = true;
        config.enable_completed_download_handling = true;
      };
    };

    features.media-server.configarr.parts.radarr.instance2 = {
      include = [
        {
          # TRASH quality defs
          template = "aed34b9f60ee115dfa7918b742336277";
          source = "TRASH";
        }
      ];
      base_url = "http://radarr-uhd:7878";
      api_key = config.sops.placeholder."radarr/api-key";
      delete_unmanaged_custom_formats.enabled = true;
      delete_unmanaged_quality_profiles.enabled = true;
      root_folders = ["/data/media/movies-uhd"];

      media_naming = {
        folder = "emby-tmdb";
        movie = {
          rename = true;
          standard = "emby-tmdb";
        };
      };

      quality_profiles = [
        {
          name = "UHD";
          reset_unmatched_scores.enabled = true;
          upgrade = {
            allowed = true;
            until_quality = "Remux-2160p";
            until_score = 10000;
            min_format_score = 1;
          };
          min_format_score = 0;
          quality_sort = "top";
          qualities = [
            {
              name = "Remux-2160p";
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
            "fb392fb0d61a010ae38e49ceaa24a1ef" # 2160p
            "493b6d1dbec3c3364c59d7607f7e3405" # HDR
            "b337d6812e06c200ec9a2d3cfa9d20a7" # DV Boost
            "923b6abef9b17f937fab56cfcf89e1f1" # DV (w/o HDR fallback)
            "caa37d0df9c348912df1fb1d88f9273a" # HDR10+ Boost
            "f700d29429c023a5734505e77daeaea7" # DV (Disk)

            # Unwanted
            "cae4ca30163749b891686f95532519bd" # AV1
            "b6832f586342ef70d9c128d40c07b872" # Dual groups
            "b8cd450cbfa689c0259a01d9e29ba3d6" # 3D
            "ed38b889b31be83fda192888e2286d83" # BR-DISK
            "e6886871085226c3da1830830146846c" # Generated HDR
            "c465ccc73923871b3eb1802042331306" # Line/Mic Dubbed
            "90a6f9a284dff5103f6346090e6280c8" # Low-qual
            "ae9b7c9ebde1f3bd336a8cbd1ec4c5e5" # Stripped group
            "bfd8eb01832d646a0a89c4deb46f8564" # Upscaled

            # Language
            "d6e9318c875905d6cfb5bee961afcea9" # Original only

            # High-qual groups
            "3a3ff47579026e76d6504ebea39390de" # RMX T1
            "9f98181fe5a3fbeb0cc29340da2a468a" # RMX T2
            "8baaf0b3142bf4d94c42a724f034e27a" # RMX T3
            "ed27ebfef2f323e964fb1f61391bcb35" # HD BR T1
            "c20c8647f2746a1f4c4262b0fbbeeeae" # HD BR T2
            "5608c71bcebba0a5e666223bae8c9227" # HD BR T3
            "c20f169ef63c5f40c2def54abaf4438e" # WEB T1
            "403816d65392c79236dcb6dd591aeda4" # WEB T2
            "af94e0fe497124d1f9ce732069ec8c3b" # WEB T3
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
              # Audio Formats
              id = "9d5acd8f1da78dfbae788182f7605200";
              include_unrequired = true;
            }
            {
              # Audio Channels
              id = "71660f8c0900b2de202181efb0ca1c88";
              include_unrequired = true;
            }
            {
              # Repack/Proper
              id = "d688ff99733a9bc626c37eb61ea74704";
              include_unrequired = true;
            }
            {
              # Streaming Services
              id = "d9cc9a504e5ede6294c8b973aad4f028";
              include_unrequired = true;
            }
            {
              # Movie Editions
              id = "f4f1474b963b24cf983455743aa9906c";
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
              api_key = config.sops.placeholder."nzbdav/api-key";
              use_ssl = false;
              url_base = "/";
              movie_category = "movies-uhd";
            };
          }
        ];
        delete_unmanaged.enabled = true;
        config.enable_completed_download_handling = true;
      };
    };

    features.media-server.caddy.virtualHosts = {
      "radarr.emns.dev" = ''
        reverse_proxy radarr:7878
      '';

      "uhd.radarr.emns.dev" = ''
        reverse_proxy radarr-uhd:7878
      '';
    };
  };
}
