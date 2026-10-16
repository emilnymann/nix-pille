_: {
  flake.homeModules.aws-cli = {...}: {
    programs.awscli = {
      enable = true;
      settings = {
        "sso-session uniify" = {
          sso_start_url = "https://uniify.awsapps.com/start";
          sso_region = "eu-central-1";
          sso_registration_scopes = "sso:account:access";
        };

        "profile uniify-dev" = {
          sso_session = "uniify";
          sso_account_id = "244924578833";
          sso_role_name = "PowerUserAccess";
          region = "eu-central-1";
          output = "json";
        };
      };
    };
  };
}
