_: {
  flake.homeModules.version-control = {pkgs, ...}: {
    programs = {
      git = {
        enable = true;
      };

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

      difftastic = {
        enable = true;
        jujutsu.enable = true;
      };

      gh = {
        enable = true;
      };
    };

    home.packages = with pkgs; [
      tuicr
      blazingjj
    ];
  };
}
