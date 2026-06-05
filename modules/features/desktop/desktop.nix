_: {
  flake.nixosModules.desktop =
    {
      pkgs,
      ...
    }:
    {
      config = {
        programs.hyprland = {
          enable = true;
        };

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

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-termfilechooser
        ];
        config = {
          hyprland = {
            default = [
              "hyprland"
            ];
            "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
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
