_: {
  flake.homeModules.desktop =
    {
      osConfig,
      lib,
      pkgs,
      ...
    }:
    lib.mkIf osConfig.programs.hyprland.enable {
      programs.ashell = {
        enable = true;
        systemd.enable = true;
        settings = {
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

          media_player = {
            indicator_format = "IconAndTitle";
          };

          notifications = {
            grouped = true;
          };

          settings = {
            peripheral_indicators = "All";
            indicators = [
              "Audio"
              "Microphone"
              "Network"
              "Bluetooth"
              "PeripheralBattery"
            ];
            bluetooth_more_cmd = "${lib.getExe pkgs.ghostty} -e ${lib.getExe pkgs.bluetui}";
          };

          tempo = {
            clock_format = "%R • %e";
          };

          tray = {
            right_click = "menu";
          };

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
      };
    };
}
