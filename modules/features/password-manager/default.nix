_: {
  flake.homeModules.password-manager = _: {
    programs.glide-browser = {
      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
      };
    };
  };
}
