_: {
  flake.nixosModules.media-server = {config, ...}: {
    users.users.nzbget = {
      isSystemUser = true;
      group = config.users.groups.media.name;
      uid = 981;
    };

    sops.secrets."media_server/nzbget/conf".restartUnits = ["podman-nzbget.service"];

    sops.templates."nzbget.conf" = {
      owner = "nzbget";
      restartUnits = ["podman-nzbget.service"];
      content = ''
        # --- paths (match the container's volumes) ---
        MainDir=/data/nzbget
        DestDir=''${MainDir}/completed
        InterDir=''${MainDir}/intermediate
        NzbDir=''${MainDir}/nzb
        QueueDir=/config/queue
        TempDir=/config/tmp
        ScriptDir=/config/scripts
        LogFile=/config/nzbget.log
        LockFile=/config/nzbget.lock

        # --- app-provided paths (from the image's default config). AppDir is
        WebDir=''${AppDir}/webui
        ConfigTemplate=''${AppDir}/webui/nzbget.conf.template
        CertStore=''${AppDir}/cacert.pem
        CertCheck=yes
        UnrarCmd=''${AppDir}/unrar
        SevenZipCmd=''${AppDir}/7za

        # --- control / web UI ---
        ControlIP=0.0.0.0
        ControlPort=6789
        SecureControl=no

        # --- behaviour ---
        AppendCategoryDir=yes
        DirectWrite=yes
        WriteBuffer=1024
        ArticleCache=500
        ParCheck=auto
        ParRepair=yes
        Unpack=yes
        ShellOverride=.py=/usr/bin/python3

        # --- logging ---
        WriteLog=rotate
        RotateLog=3
        ErrorTarget=both
        WarningTarget=both
        InfoTarget=both
        DetailTarget=log

        # --- secret fragment (servers, credentials, control password) ---
        ${config.sops.placeholder."media_server/nzbget/conf"}
      '';
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
        "${config.sops.templates."nzbget.conf".path}:/config/nzbget.conf:ro"
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
