{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosConfigurations.xenon = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.xenon
        self.nixosModules.myHomeManager
        inputs.stylix.nixosModules.stylix
      ];
    };

    nixosModules.xenon =
      { pkgs, ... }:
      {
        imports = with self.nixosModules; [
          ./hardware-configuration.nix

          smart-shell
          trashcan
          gpg-ssh
          theming
        ];

        networking.useDHCP = false;
        systemd.network = {
          enable = true;
          networks."10-wan" = {
            matchConfig.MACAddress = "b4:2e:99:48:18:cd";
            networkConfig = {
              Gateway = "95.217.37.193";
              DNS = [
                "185.12.64.1"
                "185.12.64.2"
              ];
            };
            addresses = [
              {
                Address = "95.217.37.253/32";
                Peer = "95.217.37.193/32";
              }
            ];
          };
        };

        boot.loader.grub = {
          enable = true;
          devices = [
            "/dev/disk/by-id/ata-HGST_HUH721008ALE600_7HKK5VXJ" # sda
            "/dev/disk/by-id/ata-HGST_HUH721008ALE600_7HKKSVXJ" # sdb
          ];
        };

        boot.swraid.mdadmConf = ''
          MAILADDR root
        '';

        services.smartd = {
          enable = true;
          notifications.wall.enable = true;
        };

        services.openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "prohibit-password";
          };
        };

        security = {
          sudo.enable = true;
          sudo.wheelNeedsPassword = false;
        };

        time.timeZone = "Europe/Copenhagen";
        location.provider = "geoclue2";
        console.keyMap = "dk-latin1";
        i18n = {
          defaultLocale = "en_DK.UTF-8";
          extraLocaleSettings = {
            LC_ADDRESS = "da_DK.UTF-8";
            LC_IDENTIFICATION = "da_DK.UTF-8";
            LC_MEASUREMENT = "da_DK.UTF-8";
            LC_MONETARY = "da_DK.UTF-8";
            LC_NAME = "da_DK.UTF-8";
            LC_NUMERIC = "da_DK.UTF-8";
            LC_PAPER = "da_DK.UTF-8";
            LC_TELEPHONE = "da_DK.UTF-8";
            LC_TIME = "da_DK.UTF-8";
          };
        };

        nix = {
          settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          optimise.automatic = true;
          gc = {
            automatic = true;
            randomizedDelaySec = "14m";
            options = "--delete-older-than 10d";
          };
        };

        nixpkgs.config.allowUnfree = true;
        hardware.enableRedistributableFirmware = true;

        users = {
          users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHp2+MUwKg4vv7M2I5kyCWwlmyKQL++/VasEqj7/GFhC openpgp:0x2FF97ABE"
          ];
          users.ens = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            shell = pkgs.fish;
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHp2+MUwKg4vv7M2I5kyCWwlmyKQL++/VasEqj7/GFhC openpgp:0x2FF97ABE"
            ];
          };
        };

        home-manager = {
          sharedModules = [
            inputs.nixvim.homeModules.nixvim
            inputs.glide.homeModules.default
          ];
          users.ens = self.homeModules.ens;
        };

        system.stateVersion = "26.05";
      };
  };
}
