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
      aws-cli
    ];

    programs.glide-browser.profiles = {
      work = {
        id = 0;
        isDefault = true;
        name = "work";
      };
      private = {
        id = 1;
        isDefault = false;
        name = "private";
      };
    };

    home.packages = with pkgs; [
      orbstack
      hurl
    ];

    programs.git.settings.user.email = lib.mkForce "ens@uniify.io";
    programs.jujutsu.settings.user.email = lib.mkForce "ens@uniify.io";
    programs.man.generateCaches = false;
  };
}
