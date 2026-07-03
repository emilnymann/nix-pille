{
  self,
  ...
}:
{
  flake.homeModules.ens-base = {
    imports = with self.homeModules; [
      neovim-ide
      git-tui
      smart-shell
      coding-agent
    ];

    programs.git.settings = {
      user = {
        name = "Emil Nymann Sølyst";
        email = "emilnymann96@gmail.com";
        signingkey = "45E51048D62204CCD70B633B31D710749D7D8E7B";
      };
      commit.gpgsign = true;
      tag.gpgsign = true;
    };

    xdg.enable = true;
    home.stateVersion = "26.05";
  };
}
