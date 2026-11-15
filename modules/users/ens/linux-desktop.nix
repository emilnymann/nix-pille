{self, ...}: {
  flake.homeModules.ens-linux-desktop = {config, osConfig, lib, ...}: {
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

    wayland.windowManager.hyprland.settings.config = lib.mkIf osConfig.programs.hyprland.enable {
      general = {
        gaps_in = 4;
        gaps_out = 4;
      };

      decoration = {
        rounding = 8;
      };

      cursor = {
        inactive_timeout = 6;
      };

      input = {
        kb_model = "pc104";
        kb_layout = "us";
        kb_variant = "mac";
        kb_options = "ctrl:nocaps,lv3:alt_switch";
        repeat_delay = 450;
        repeat_rate = 67;

        touchpad = {
          natural_scroll = true;
        };
      };
    };

    services.hyprpaper.settings.wallpaper = [
      {
        monitor = "";
        path = "${./wallpapers}";
      }
    ];
  };
}
