{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosConfigurations.cadmium = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.cadmium
        self.nixosModules.myHomeManager
      ];
    };

    nixosModules.cadmium = {pkgs, ...}: {
      imports = with self.nixosModules; [
        ./hardware-configuration.nix
        smart-shell
        bluetooth
        desktop
        trashcan
        gpg-ssh
        theming
        gaming
      ];

      features.theming.colorscheme = "gruvbox-material-dark-medium";

      environment.systemPackages = with pkgs; [
        sops
        btop
      ];

      networking = {
        hostName = "cadmium";
        networkmanager.enable = true;
        nftables.enable = true;
        firewall.extraInputRules = ''
          ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 169.254.0.0/16 } tcp dport 22 accept
          ip6 saddr { fc00::/7, fe80::/10 } tcp dport 22 accept
        '';
      };

      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        settings.publish = {
          disable-publishing = false;
          publish-addresses = true;
        };
      };

      services.openssh = {
        enable = true;
        openFirewall = false;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };

      security = {
        sudo.enable = true;
        polkit.enable = true;
      };

      boot = {
        plymouth.enable = true;
        kernelParams = ["quiet"];
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
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
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = ["root" "@wheel"];
        };
        optimise.automatic = true;
        gc = {
          automatic = true;
          randomizedDelaySec = "14m";
          options = "--delete-older-than 10d";
        };
      };

      nixpkgs.config.allowUnfree = true;

      system.stateVersion = "26.05";

      hardware.graphics.enable = true;
      hardware.enableRedistributableFirmware = true;

      security.sudo.wheelNeedsPassword = false;

      users = {
        users.janeski = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "networkmanager"
            "audio"
            "video"
            "input"
          ];

          shell = pkgs.fish;

          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHp2+MUwKg4vv7M2I5kyCWwlmyKQL++/VasEqj7/GFhC openpgp:0x2FF97ABE"
          ];
        };
      };

      home-manager.users.janeski = self.homeModules.janeski;

      services.displayManager.autoLogin.user = "janeski";

      services.resolved = {
        enable = true;
        settings.Resolve.MulticastDNS = false;
      };
    };
  };
}
