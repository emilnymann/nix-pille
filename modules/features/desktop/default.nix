_: {
  flake.nixosModules.desktop = {pkgs, ...}: {
    environment.systemPackages = [pkgs.wl-clipboard];

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

  flake.homeModules.desktop = {
    osConfig,
    pkgs,
    lib,
    ...
  }: let
    power-menu = pkgs.writeShellScriptBin "power-menu" ''
      choice=$(printf 'Shutdown\nReboot' | ${lib.getExe pkgs.vicinae} dmenu)

      case "$choice" in
        Shutdown) ${pkgs.systemd}/bin/systemctl poweroff ;;
        Reboot) ${pkgs.systemd}/bin/systemctl reboot ;;
      esac
    '';
  in
    lib.mkIf osConfig.programs.hyprland.enable {
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
            "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
          };
        };
      };

      xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = lib.generators.toINI {} {
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

  flake.darwinModules.desktop = _: {
    services.aerospace = {
      enable = true;
      settings = {
        automatically-unhide-macos-hidden-apps = true;
        gaps = {
          inner = {
            horizontal = 8;
            vertical = 8;
          };
          outer = {
            left = 8;
            right = 8;
            bottom = 8;
          };
        };
        mode.main.binding = {
          cmd-h = "focus left";
          cmd-j = "focus down";
          cmd-k = "focus up";
          cmd-l = "focus right";

          cmd-shift-h = "move left";
          cmd-shift-j = "move down";
          cmd-shift-k = "move up";
          cmd-shift-l = "move right";

          cmd-1 = "workspace 1";
          cmd-2 = "workspace 2";
          cmd-3 = "workspace 3";
          cmd-4 = "workspace 4";
          cmd-5 = "workspace 5";
          cmd-6 = "workspace 6";
          cmd-7 = "workspace 7";
          cmd-8 = "workspace 8";
          cmd-9 = "workspace 9";

          cmd-shift-1 = "move-node-to-workspace 1";
          cmd-shift-2 = "move-node-to-workspace 2";
          cmd-shift-3 = "move-node-to-workspace 3";
          cmd-shift-4 = "move-node-to-workspace 4";
          cmd-shift-5 = "move-node-to-workspace 5";
          cmd-shift-6 = "move-node-to-workspace 6";
          cmd-shift-7 = "move-node-to-workspace 7";
          cmd-shift-8 = "move-node-to-workspace 8";
          cmd-shift-9 = "move-node-to-workspace 9";

          cmd-w = "close";

          cmd-f = "fullscreen";
        };
      };
    };
  };
}
