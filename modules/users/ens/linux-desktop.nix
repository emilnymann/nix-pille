{
  self,
  ...
}:
{
  flake.homeModules.ens-linux-desktop = {
    imports = with self.homeModules; [
      desktop
      bluetooth
      file-browser
      web-browser
      password-manager
      terminal-emulator
      theming
      discord
    ];

    services.hyprpaper.settings.wallpaper = [
      {
        monitor = "";
        path = "${./wallpapers}";
      }
    ];
  };
}
