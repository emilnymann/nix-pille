{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosConfigurations.argon = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.argon
        self.nixosModules.myHomeManager
        inputs.stylix.nixosModules.stylix
      ];
    };

    nixosModules.argon =
      { pkgs, ... }:
      {
        imports = with self.nixosModules; [
          ./hardware-configuration.nix

          smart-shell
          desktop
          theming
          gpg-ssh
        ];

        networking = {
          hostName = "argon";
          networkmanager.enable = true;
        };

        security = {
          sudo.enable = true;
          polkit.enable = true;
        };

        boot = {
          plymouth.enable = true;
          kernelParams = [ "quiet" ];
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
          defaultUserShell = pkgs.bash;
          users.ens = {
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

        home-manager = {
          sharedModules = [
            inputs.nixvim.homeModules.nixvim
          ];
          users.ens = self.homeModules.ens;
        };

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              user = "ens";
              command = "uwsm start hyprland-uwsm.desktop";
            };
          };
        };
      };
  };
}
