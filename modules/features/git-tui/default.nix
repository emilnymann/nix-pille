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

      lazygit = {
        enable = true;
        settings = {
          git = {
            overrideGpg = true;
            pagers = [{pager = "delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";}];
          };
        };
      };

      gh = {
        enable = true;
      };
    };
  };
}
