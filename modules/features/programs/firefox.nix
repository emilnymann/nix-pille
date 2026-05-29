{ self, inputs, ... }:
{
  flake.nixosModules.firefox =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      withBitwarden = config.programs.bitwarden.enable;
    in
    {
      programs.firefox = {
        enable = true;
        policies = lib.mkMerge [
          {
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
            ExtensionSettings = {
              # Tridactyl
              "tridactyl.vim.betas@cmcaine.co.uk" = {
                install_url = "https://tridactyl.cmcaine.co.uk/betas/tridactyl-latest.xpi";
                installation_mode = "normal_installed";
              };
            };
          }

          (lib.mkIf withBitwarden {
            AutofillAddressEnabled = false;
            AutofillCreditCardEnabled = false;
            OfferToSaveLogins = false;
            PasswordManagerEnabled = false;
            ExtensionSettings = {
              # Bitwarden
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = lib.mkIf withBitwarden {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                installation_mode = "force_installed";
              };
            };
          })
        ];
      };
    };
}
