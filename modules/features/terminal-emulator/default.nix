_: {
  flake.homeModules.terminal-emulator =
    {
      osConfig,
      pkgs,
      config,
      lib,
      ...
    }:
    let
      withHyprland = config.wayland.windowManager.hyprland.enable;
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

      config = lib.mkIf osConfig.programs.hyprland.enable {
        programs.ghostty = {
          enable = true;
          settings = {
            window-padding-x = 16;
            window-padding-y = 16;
          };
        };

        xdg.terminal-exec = {
          enable = true;
          settings.default = [ "ghostty.desktop" ];
        };

        features.terminal-emulator = {
          bin = "${pkgs.ghostty}/bin/ghostty";
          titleFlag = "--title=";
          execFlag = "-e";
        };

        wayland.windowManager.hyprland.settings = lib.mkIf withHyprland {
          terminal = {
            _var = "${pkgs.ghostty}/bin/ghostty";
          };
        };
      };
    };
}
