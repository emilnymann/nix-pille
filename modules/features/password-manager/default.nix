_: {
  flake.homeModules.password-manager = {config, lib, ...}: let
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
    };
    program = config.features.web-browser.program;
  in {
    programs.firefox.policies = lib.mkIf (program == "firefox") policies;
    programs.glide-browser.policies = lib.mkIf (program == "glide") policies;
  };
}
