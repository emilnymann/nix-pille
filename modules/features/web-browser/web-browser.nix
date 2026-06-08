_: {
  flake.homeModules.web-browser =
    {
      config,
      lib,
      ...
    }:
    let
      withHyprland = config.wayland.windowManager.hyprland.enable;
    in
    {
      xdg.configFile."glide/glide.ts".source = ./glide/glide.ts;

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

      wayland.windowManager.hyprland.settings = lib.mkIf withHyprland {
        browser = {
          _var = lib.getExe config.programs.glide-browser.package;
        };
      };
    };
}
