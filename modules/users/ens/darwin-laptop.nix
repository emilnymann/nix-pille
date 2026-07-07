{
  self,
  lib,
  ...
}: {
  flake.homeModules.ens-darwin-laptop = {
    imports = with self.homeModules; [
      ens-base
      file-browser
      web-browser
      terminal-emulator
      theming
      onepassword
    ];

    programs.git.settings.user.email = lib.mkForce "ens@uniify.io";
    programs.man.generateCaches = false;
  };
}
