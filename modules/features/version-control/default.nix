_: {
  flake.homeModules.version-control = _: {
    programs = {
      jujutsu = {
        enable = true;
        settings = {
          signing = {
            behavior = "own";
            backend = "gpg";
          };
          ui = {
            editor = ["nvim" "+$line"];
          };
        };
      };

      delta = {
        enable = true;
        enableJujutsuIntegration = true;
      };
    };
  };
}
