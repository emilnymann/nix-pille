_: {
  flake.nixosModules.desktop = _: {
    config = {
      programs.hyprland = {
        enable = true;
      };

      services.upower.enable = true;

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
    let
      power-menu = pkgs.writeShellScriptBin "power-menu" ''
        choice=$(printf 'Shutdown\nReboot' | ${lib.getExe pkgs.vicinae} dmenu)

        case "$choice" in
          Shutdown) ${pkgs.systemd}/bin/systemctl poweroff ;;
          Reboot) ${pkgs.systemd}/bin/systemctl reboot ;;
        esac
      '';
    in
    {
      imports = [
        ./hyprland/_config.nix
        ./hyprland/_monitors.nix
        ./hyprland/_binds.nix
        ./_ashell.nix
        ./vicinae/_extensions.nix
      ];

      home.packages = with pkgs; [
        wl-clipboard
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          launcher._var = "${lib.getExe pkgs.vicinae} open";
          power_menu._var = "${lib.getExe power-menu}";
          cliphist._var = "${lib.getExe pkgs.vicinae} deeplink vicinae://launch/clipboard/history";
          which_key._var = "${lib.getExe pkgs.vicinae} deeplink vicinae://launch/@sovereign/hypr-keybinds/hyprland-keybinds";
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

      programs.vicinae = {
        enable = true;
        systemd.enable = true;
      };

      services.hyprpaper = {
        enable = true;
        settings = {
          splash = false;
        };
      };
    };
}
