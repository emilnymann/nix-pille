_: {
  flake.homeModules.password-manager =
    { osConfig, lib, ... }:
    lib.mkIf osConfig.programs.hyprland.enable {
      programs.glide-browser = {
        policies = {
          AutofillAddressEnabled = false;
          AutofillCreditCardEnabled = false;
          OfferToSaveLogins = false;
          PasswordManagerEnabled = false;
        };
      };

      features.web-browser.glide.extensionLines = [
        "glide.addons.install('https://addons.mozilla.org/firefox/downloads/file/4827854/bitwarden_password_manager-2026.5.0.xpi', { force: true, private_browsing_allowed: true });"
      ];
    };

}
