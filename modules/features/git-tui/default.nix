_: {
  flake.homeModules.git-tui = _: {
    programs.git.enable = true;
    programs.lazygit = {
      enable = true;
    };
  };
}
