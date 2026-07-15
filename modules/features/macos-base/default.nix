_: {
  flake.darwinModules."macos-base" = {pkgs, ...}: {
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
        InitialKeyRepeat = 30;
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

    environment.shells = [pkgs.fish];

    environment.systemPackages = with pkgs; [
      git
      curl
      jq
      sops
      posting
    ];

    programs.fish.enable = true;

    documentation.doc.enable = false;
    system.tools.darwin-uninstaller.enable = false;

    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
