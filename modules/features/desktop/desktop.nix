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
        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
          pkgs.xdg-desktop-portal-gtk
        ];
      };

      fonts.packages = with pkgs; [ font-awesome_4 ];
      programs.waybar.enable = true;
    };

  flake.homeModules.desktop =
    {
      lib,
      osConfig,
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
