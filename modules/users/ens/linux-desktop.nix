{self, ...}: {
  flake.homeModules.ens-linux-desktop = {
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

    services.hyprpaper.settings.wallpaper = [
      {
        monitor = "";
        path = "${./wallpapers}";
      }
    ];
  };
}
