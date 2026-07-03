_: {
  flake.homeModules.terminal-emulator =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      withHyprland = config.wayland.windowManager.hyprland.enable;
      ghosttyPackage = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
      ghosttyExe = lib.getExe ghosttyPackage;
    in
    {
      options.features.terminal-emulator = {
        bin = lib.mkOption {
          type = lib.types.str;
        };

        titleFlag = lib.mkOption {
          type = lib.types.str;
        };

        execFlag = lib.mkOption {
          type = lib.types.str;
        };
      };

      config = {
        programs.ghostty = {
          enable = true;
          package = ghosttyPackage;
          settings = {
            window-padding-x = 16;
            window-padding-y = 16;
          };
        };

        features.terminal-emulator = {
          bin = ghosttyExe;
          titleFlag = "--title=";
          execFlag = "-e";
        };

        xdg.terminal-exec = lib.mkIf config.xdg.enable {
          enable = true;
          settings.default = [ "ghostty.desktop" ];
        };

        wayland.windowManager.hyprland.settings = lib.mkIf withHyprland {
          terminal = {
            _var = ghosttyExe;
          };
        };
      };
    };
}
