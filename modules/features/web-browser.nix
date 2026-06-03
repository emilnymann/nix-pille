_: {
  flake.homeModules.web-browser =
    { config, ... }:
    {
      programs.firefox = {
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

      stylix.targets.firefox.profileNames = [ config.home.username ];
    };
}
