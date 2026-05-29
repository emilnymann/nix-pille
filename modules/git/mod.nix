{ flake.nixosModules.git = { ... }: {
  programs.git.enable = true;

  hjem.users.ens = {
    xdg.config.files."git/config".text = ''
      [user]
        name = Emil Nymann Sølyst
	email = emilnymann96@gmail.com
	signingkey = 45E51048D62204CCD70B633B31D710749D7D8E7B
      [commit]
        gpgsign = true
      [tag]
        gpgsign = true
    '';
  };
}; }
