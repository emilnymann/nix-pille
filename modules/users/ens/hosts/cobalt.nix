{
  self,
  lib,
  ...
}: {
  flake.darwinModules.cobalt = _: {
    home-manager.users.ens = {pkgs, ...}: {
      imports = with self.homeModules; [
        aws-cli
        onepassword
      ];

      programs.google-chrome.enable = true;

      programs.glide-browser.profiles = {
        work = {
          id = 0;
          isDefault = true;
          name = "work";
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
  };
}
