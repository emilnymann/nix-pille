_: {
  flake.homeModules.ens = _: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        cadmium = {
          HostName = "cadmium.local";
          User = "janeski";
        };
        xenon = {
          HostName = "emns.dev";
          User = "ens";
        };
      };
    };
  };
}
