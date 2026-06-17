_: {
  flake.nixosModules.media-server = {
    lib,
    config,
    ...
  }: {
    users.users.nzbget = {
      isSystemUser = true;
      group = config.users.groups.media.name;
      uid = 981;
    };

    sops = {
      secrets = {
        "nzbget/username".restartUnits = ["podman-nzbget.service"];
        "nzbget/password".restartUnits = ["podman-nzbget.service"];
        "nzbget/servers/server1/username".restartUnits = ["podman-nzbget.service"];
        "nzbget/servers/server1/password".restartUnits = ["podman-nzbget.service"];
        "nzbget/servers/server2/username".restartUnits = ["podman-nzbget.service"];
        "nzbget/servers/server2/password".restartUnits = ["podman-nzbget.service"];
      };

      templates."nzbget/nzbget.conf" = {
        owner = "nzbget";
        restartUnits = ["podman-nzbget.service"];
        content = lib.generators.toKeyValue {} {
          ControlUsername = config.sops.placeholder."nzbget/username";
          ControlPassword = config.sops.placeholder."nzbget/password";

          # --- paths (match the container's volumes) ---
          MainDir = "/data/nzbget";
          DestDir = "/data/nzbget/completed";
          InterDir = "/data/nzbget/intermediate";
          NzbDir = "/data/nzbget/nzb";
          QueueDir = "/config/queue";
          TempDir = "/config/tmp";
          ScriptDir = "/config/scripts";
          LogFile = "/config/nzbget.log";
          LockFile = "/config/nzbget.lock";

          # --- app-provided paths (from the image's default config). AppDir is
          WebDir = "\${AppDir}/webui";
          ConfigTemplate = "\${AppDir}/webui/nzbget.conf.template";
          CertStore = "\${AppDir}/cacert.pem";
          CertCheck = "yes";
          UnrarCmd = "\${AppDir}/unrar";
          SevenZipCmd = "\${AppDir}/7za";

          # --- control / web UI ---
          ControlIP = "0.0.0.0";
          ControlPort = 6789;
          SecureControl = "no";

          # --- behaviour ---
          AppendCategoryDir = "yes";
          DirectWrite = "yes";
          WriteBuffer = 1024;
          ArticleCache = 500;
          ParCheck = "auto";
          ParRepair = "yes";
          Unpack = "yes";
          ShellOverride = ".py=/usr/bin/python3";

          # --- logging ---
          WriteLog = "rotate";
          RotateLog = 3;
          ErrorTarget = "both";
          WarningTarget = "both";
          InfoTarget = "both";
          DetailTarget = "log";

          # --- servers ---
          "Server1.Active" = "yes";
          "Server1.Name" = "Ninja";
          "Server1.Host" = "news.newsgroup.ninja";
          "Server1.Port" = 563;
          "Server1.Username" = config.sops.placeholder."nzbget/servers/server1/username";
          "Server1.Password" = config.sops.placeholder."nzbget/servers/server1/password";
          "Server1.Encryption" = "yes";
          "Server1.Connections" = 50;
          "Server1.Retention" = 6500;
          "Server1.Level" = 0;

          "Server2.Active" = "yes";
          "Server2.Name" = "Farm";
          "Server2.Host" = "news.usenet.farm";
          "Server2.Port" = "563";
          "Server2.Username" = config.sops.placeholder."nzbget/servers/server2/username";
          "Server2.Password" = config.sops.placeholder."nzbget/servers/server2/password";
          "Server2.Encryption" = "yes";
          "Server2.Connections" = 50;
          "Server2.Level" = 1;

          # --- categories ---
          "Category1.Name" = "Movies";
          "Category1.DestDir" = "/data/nzbget/completed/Movies";

          "Category2.Name" = "MoviesUHD";
          "Category2.DestDir" = "/data/nzbget/completed/MoviesUHD";

          "Category3.Name" = "TV";
          "Category3.DestDir" = "/data/nzbget/completed/TV";

          "Category4.Name" = "TVUHD";
          "Category4.DestDir" = "/data/nzbget/completed/TVUHD";
        };
      };
    };

    virtualisation.oci-containers.containers.nzbget = {
      image = "ghcr.io/hotio/nzbget:release-26.1";
      environment = {
        PUID = toString config.users.users.nzbget.uid;
        PGID = toString config.users.groups.media.gid;
        UMASK = "002";
        TZ = "Europe/Copenhagen";
      };
      networks = ["media"];
      volumes = [
        "/srv/media:/data"
        "nzbget-config:/config"
        "${config.sops.templates."nzbget/nzbget.conf".path}:/config/nzbget.conf:ro"
      ];
    };

    systemd.services."podman-nzbget" = {
      requires = ["podman-network-media-create.service"];
      after = ["podman-network-media-create.service"];
    };

    features.media-server.caddy.virtualHosts."nzbget.emns.dev" = ''
      reverse_proxy nzbget:6789
    '';
  };
}
