{
  self,
  inputs,
  ...
}: {
  flake = {
    darwinConfigurations.cobalt = inputs.nix-darwin.lib.darwinSystem {
      modules = [
        self.darwinModules.cobalt
        self.darwinModules.gpg-ssh
        self.darwinModules.myHomeManager
        inputs.stylix.darwinModules.stylix
      ];
    };

    darwinModules.cobalt = { pkgs, ... }: {
      networking.hostName = "cobalt";

      system.primaryUser = "ens";
      users.users.ens = {
        home = "/Users/ens";
        shell = pkgs.fish;
      };

      nix = {
        settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
        optimise.automatic = true;
      };

      nixpkgs = {
        hostPlatform = "aarch64-darwin";
        config.allowUnfree = true;
      };

      system.defaults = {
        NSGlobalDomain = {
          ApplePressAndHoldEnabled = false;
          InitialKeyRepeat = 10;
          KeyRepeat = 1;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
        };

        dock = {
          autohide = true;
          mru-spaces = false;
          showhidden = true;
        };

        finder = {
          AppleShowAllExtensions = true;
          FXEnableExtensionChangeWarning = false;
        };
      };

      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToControl = true;

      environment.shells = [ pkgs.fish ];

      environment.systemPackages = with pkgs; [
        git
        curl
        jq
      ];

      programs.fish.enable = true;

      home-manager = {
        sharedModules = [
          inputs.nixvim.homeModules.nixvim
          inputs.glide.homeModules.default
          inputs.stylix.homeModules.stylix
        ];

        users.ens = {
          imports = [
            self.homeModules.ens-darwin-laptop
          ];

          home.username = "ens";
          home.homeDirectory = "/Users/ens";

          programs.fish.shellAbbrs = {
            drs = "sudo nix run nix-darwin -- switch --flake ~/dev/nix-darwin#cobalt";
          };
        };
      };

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
    };
  };
}
