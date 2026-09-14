{self, ...}: {
  flake.homeModules.ens-linux-desktop = {
    imports = with self.homeModules; [
      desktop
      bluetooth
      file-browser
      web-browser
      web-browser-private-profiles
      terminal-emulator
      theming
      discord
      bitwarden
    ];

    services.hyprpaper.settings.wallpaper = [
      {
        monitor = "";
        path = "${./wallpapers}";
      }
    ];
  };
}
