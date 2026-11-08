{self, ...}: {
  flake.homeModules.ens-linux-desktop = {config, ...}: {
    imports = with self.homeModules; [
      desktop
      bluetooth
      file-browser
      web-browser
      terminal-emulator
      theming
      discord
      bitwarden
    ];

    programs.glide-browser.profiles.${config.home.username} = {
      isDefault = true;
      name = config.home.username;
    };

    features.theming.cursor = "BreezeX-Dark";

    services.hyprpaper.settings.wallpaper = [
      {
        monitor = "";
        path = "${./wallpapers}";
      }
    ];
  };
}
