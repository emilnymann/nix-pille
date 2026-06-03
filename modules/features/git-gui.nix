_: {
  flake.homeModules.git-gui = _: {
    programs.git.enable = true;
    programs.lazygit = {
      enable = true;
    };
  };
}
