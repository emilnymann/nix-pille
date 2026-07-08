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
      docker
      docker-compose
    ];

    programs.docker-cli.enable = true;

    services.colima = {
      enable = true;
      profiles.default = {
        isActive = true;
        isService = true;
        setDockerHost = true;
        settings.runtime = "docker";
      };
    };

    programs.git.settings.user.email = lib.mkForce "ens@uniify.io";
    programs.man.generateCaches = false;
  };
}
