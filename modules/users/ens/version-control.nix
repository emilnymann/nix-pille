_: {
  flake.homeModules.ens = _: {
    programs.git.settings = {
      user = {
        name = "Emil Nymann Sølyst";
        email = "emilnymann96@gmail.com";
        signingkey = "45E51048D62204CCD70B633B31D710749D7D8E7B";
      };
      commit.gpgsign = true;
      tag.gpgsign = true;
    };

    programs.jujutsu.settings = {
      user = {
        name = "Emil Nymann Sølyst";
        email = "emilnymann96@gmail.com";
      };
      signing = {
        behavior = "own";
        backend = "gpg";
      };
    };
  };
}
