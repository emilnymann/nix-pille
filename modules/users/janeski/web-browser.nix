_: {
  flake.homeModules.janeski = {config, ...}: {
    programs.firefox.profiles.${config.home.username} = {
      isDefault = true;
      name = config.home.username;
    };
  };
}
