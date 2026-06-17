_: {
  flake.nixosModules.media-server = {
    pkgs,
    config,
    ...
  }: {
    users.users.configarr = {
      isSystemUser = true;
      uid = 983;
      group = "media";
    };

    sops = {
      templates = {
        "configarr/config.yml" = {
          owner = "configarr";
          file = (pkgs.formats.yaml {}).generate "configarr-config.yml" {
            sonarrEnabled = true;
            radarrEnabled = false;
            whisparrEnabled = false;
            readarrEnabled = false;
            lidarrEnabled = false;

            sonarr = {
              instance1 = {
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
                  series = "default";
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
                      "15a05bc7c1a36e2b57fd628f8977e2fc" # AV1
                      "32b367365729d530ca1c124a0b180c64" # Dual groups
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

                      # Streaming Services
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

                delay_profiles = {
                  default = {
                    enableUsenet = true;
                    enableTorrent = false;
                    preferredProtocol = "usenet";
                    usenetDelay = 10;
                    torrentDelay = 0;
                    bypassIfHighestQuality = false;
                    bypassIfAboveCustomFormatScore = false;
                    minimumCustomFormatScore = 0;
                  };
                };

                download_clients = {
                  data = [
                    {
                      name = "NZBGet";
                      type = "Nzbget";
                      enable = true;
                      priority = 1;
                      remove_completed_downloads = true;
                      remove_failed_downloads = true;
                      fields = {
                        host = "nzbget";
                        port = 6789;
                        use_ssl = false;
                        url_base = "/";
                        username = config.sops.placeholder."nzbget/username";
                        password = config.sops.placeholder."nzbget/password";
                        tv_category = "TV";
                      };
                    }
                  ];
                  delete_unmanaged.enabled = true;
                  config = {
                    enable_completed_download_handling = true;
                  };
                };
              };
            };
          };
        };
      };
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
}
