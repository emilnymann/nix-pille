_: {
  flake.homeModules.terminal-emulator = {
    pkgs,
    config,
    lib,
    ...
  }: let
    ghosttyPackage =
      if pkgs.stdenv.hostPlatform.isDarwin
      then pkgs.ghostty-bin
      else pkgs.ghostty;
    ghosttyExe = lib.getExe ghosttyPackage;
  in {
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
        clearDefaultKeybinds = true;
        # settings = {
        #   keybind = [
        #   ];
        # };
      };

      features.terminal-emulator = {
        bin = ghosttyExe;
        titleFlag = "--title=";
        execFlag = "-e";
      };

      xdg.terminal-exec = lib.mkIf config.xdg.enable {
        enable = true;
        settings.default = ["ghostty.desktop"];
      };

      wayland.windowManager.hyprland.settings = {
        terminal = {
          _var = ghosttyExe;
        };
      };
    };
  };
}
