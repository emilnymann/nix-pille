_: {
  flake.homeModules.web-browser =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      withHyprland = config.wayland.windowManager.hyprland.enable;
      withStylix = config.stylix.enable;
    in
    {
      programs.glide-browser = {
        enable = true;
        profiles.${config.home.username} = {
          isDefault = true;
          name = config.home.username;
        };
        policies = {
          NoDefaultBookmarks = true;
          GenerativeAI.Enabled = false;
          AIControls.Default.Value = "blocked";
          DisableFirefoxAccounts = true;
          DisableSetDesktopBackground = true;
          DisableTelemetry = true;
          UserMessaging = {
            ExtensionRecommendations = false;
            FeatureRecommendations = false;
            UrlbarInterventions = false;
            SkipOnboarding = true;
            MoreFromMozilla = false;
          };
        };
      };

      # stylix = lib.mkIf withStylix {
      #   targets.firefox.profileNames = [ config.home.username ];
      # };

      wayland.windowManager.hyprland.settings = lib.mkIf withHyprland {
        browser = {
          _var = lib.getExe config.programs.glide-browser.package;
        };
      };
    };
}
