{self, ...}: {
  flake.nixosModules.argon = _: {
    home-manager.users.ens = {config, ...}: {
      imports = with self.homeModules; [
        bitwarden
        discord
      ];

      programs.glide-browser.profiles.${config.home.username} = {
        isDefault = true;
        name = config.home.username;
      };
    };
  };
}
