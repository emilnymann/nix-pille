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

      stylix = {
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
      };

      environment.systemPackages = with pkgs; [
        sops
        btop
      ];

      networking = {
        hostName = "cadmium";
        networkmanager.enable = true;
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
        };
      };

      home-manager.users.janeski = self.homeModules.janeski;

      services.displayManager.autoLogin.user = "janeski";

      services.resolved.enable = true;
    };
  };
}
