_: {
  flake.homeModules.web-browser-private-profiles = {config, ...}: {
    programs.glide-browser = {
      profiles.${config.home.username} = {
        isDefault = true;
        name = config.home.username;
      };
    };
  };
}
