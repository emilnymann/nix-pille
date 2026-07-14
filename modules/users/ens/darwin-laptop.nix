{
  self,
  lib,
  ...
}: {
  flake.homeModules.ens-darwin-laptop = {pkgs, ...}: {
    imports = with self.homeModules; [
      ens-base
      file-browser
      web-browser
      terminal-emulator
      theming
      onepassword
    ];

    home.packages = with pkgs; [
      orbstack
      hurl
    ];

    programs.git.settings.user.email = lib.mkForce "ens@uniify.io";
    programs.man.generateCaches = false;
  };
}
