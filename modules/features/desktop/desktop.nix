_: {
  flake.nixosModules.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      config = {
        programs.hyprland = {
          enable = true;
        };

        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gtk
            xdg-desktop-portal-termfilechooser
          ];
          config.common."org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };

        environment.pathsToLink = [
          "/share/xdg-desktop-portal"
          "/share/applications"
        ];

        fonts.packages = with pkgs; [ font-awesome_4 ];
        programs.waybar.enable = true;

        services.displayManager = {
          enable = true;
          defaultSession = "hyprland";
          sddm = {
            enable = true;
            wayland.enable = true;
          };
        };
      };
    };

  flake.homeModules.desktop =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        ./hyprland/_config.nix
        ./hyprland/_monitors.nix
        ./hyprland/_binds.nix
      ];

      home.packages = with pkgs; [
        wl-clipboard
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          launcher = {
            _var = "${pkgs.hyprlauncher}/bin/hyprlauncher";
          };
        };
      };

      xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = lib.generators.toINI { } {
        filechooser = {
          cmd = "yazi-wrapper.sh";
          default_dir = "$HOME";
          env = "TERMCMD='ghostty -e'";
          open_mode = "suggested";
          save_mode = "suggested";
        };
      };

      services.hyprlauncher = {
        enable = true;
      };

      services.hyprpaper = {
        enable = true;
        settings = {
          splash = false;
        };
      };
    };
}
