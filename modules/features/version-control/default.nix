_: {
  flake.homeModules.version-control = {pkgs, ...}: {
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

    home.packages = with pkgs; [
      tuicr
    ];
  };
}
