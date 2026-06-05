_: {
  flake.homeModules.password-manager =
    { config, ... }:
    {
      programs.rbw = {
        enable = true;
        settings = {
          email = config.accounts.email.accounts.${config.home.username}.address;
        };
      };

      programs.firefox.policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        ExtensionSettings = {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
      };
    };
}
