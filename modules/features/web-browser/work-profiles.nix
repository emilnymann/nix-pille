_: {
  flake.homeModules.web-browser-work-profiles = _: {
    programs.glide-browser = {
      profiles = {
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
    };
  };
}
