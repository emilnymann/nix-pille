_: {
  flake.homeModules.git-tui = _: {
    programs = {
      git = {
        enable = true;
      };

      delta = {
        enable = true;
        enableGitIntegration = true;
      };

      gh = {
        enable = true;
      };
    };
  };
}
