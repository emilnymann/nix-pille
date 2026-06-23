_: {
  flake.homeModules.git-tui = _: {
    programs.git.enable = true;
    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          pagers = [{pager = "delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";}];
          overrideGpg = true;
        };
      };
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
