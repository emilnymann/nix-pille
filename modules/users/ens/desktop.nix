_: {
  flake.homeModules.ens = {
    config,
    osConfig ? {},
    lib,
    pkgs,
    ...
  }: let
    hyprlandEnabled = lib.attrByPath ["programs" "hyprland" "enable"] false osConfig;
  in {
    programs.ashell.settings = lib.mkIf hyprlandEnabled {
      modules = {
        left = [
          "Workspaces"
          "WindowTitle"
        ];
        center = [
          "Tempo"
          "MediaPlayer"
        ];
        right = [
          "Tray"
          "Notifications"
          "SystemInfo"
          "Settings"
        ];
      };

      media_player.indicator_format = "IconAndTitle";
      notifications.grouped = true;

      settings = {
        peripheral_indicators = "All";
        audio_indicator_format = "IconAndPercentage";
        indicators = [
          "Audio"
          "Microphone"
          "Network"
          "Bluetooth"
          "PeripheralBattery"
        ];
        bluetooth_more_cmd = "${config.features.terminal-emulator.bin} ${config.features.terminal-emulator.execFlag} ${lib.getExe pkgs.bluetui}";
      };

      tempo.clock_format = "%R • %e";
      tray.right_click = "Menu";

      workspaces = {
        disable_special_workspaces = true;
        enable_workspace_filling = true;
        max_workspaces = 9;
        workspace_names = [
          "一"
          "二"
          "三"
          "四"
          "五"
          "六"
          "七"
          "八"
          "九"
          "十"
        ];
      };

      osd.enabled = true;
    };

    wayland.windowManager.hyprland.settings = lib.mkIf hyprlandEnabled {
      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
          scale = 0.5;
        }
        {
          fingers = 3;
          direction = "vertical";
          action = "special";
          workspace_name = "scratch";
          scale = 0.5;
        }
        {
          fingers = 3;
          direction = "pinch";
          action = "fullscreen";
        }
      ];

      config = {
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
    };

    services.hyprpaper.settings.wallpaper = lib.mkIf hyprlandEnabled [
      {
        monitor = "";
        path = "${./wallpapers}";
      }
    ];
  };
}
