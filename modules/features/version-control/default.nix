_: {
  flake.homeModules.version-control = {pkgs, ...}: {
    programs = {
      git = {
        enable = true;
      };

      jujutsu = {
        enable = true;
        settings = {
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

      tuicr = {
        enable = true;
        settings = {
          editor = "nvim";
        };
      };
    };

    home.packages = with pkgs; [
      blazingjj
    ];
  };
}
