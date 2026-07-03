{
  self,
  lib,
  ...
}:
{
  flake.homeModules.ens-darwin-laptop = {
    imports = with self.homeModules; [
      ens-base
      file-browser
      web-browser
      password-manager
      terminal-emulator
      theming
      discord
    ];

    programs.git.settings.user.email = lib.mkForce "ens@uniify.io";
  };
}
