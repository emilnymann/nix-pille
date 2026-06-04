_: {
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
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
    };

  flake.homeModules.desktop =
    {
      lib,
      osConfig,
      pkgs,
      ...
    }:
    {
      imports = [
        ./hyprland/_programs.nix
        ./hyprland/_config.nix
        ./hyprland/_monitors.nix
        ./hyprland/_binds.nix
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        systemd = lib.mkIf osConfig.programs.hyprland.withUWSM {
          enable = false;
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
