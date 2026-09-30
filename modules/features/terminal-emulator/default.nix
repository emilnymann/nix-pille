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
        settings.keybind = [
          # Keep clipboard shortcuts available in the locked/default key table.
          "super+c=copy_to_clipboard"
          "super+v=paste_from_clipboard"

          # Ctrl+G toggles the vim-style key table on and off.
          "vim/"
          "ctrl+g=activate_key_table:vim"
          "vim/ctrl+g=deactivate_key_table"

          # Tab navigation and management.
          "vim/shift+h=previous_tab"
          "vim/shift+l=next_tab"
          "vim/t>n=new_tab"
          "vim/t>d=close_tab"

          # Pane navigation, creation, and closing. Ghostty has no action to
          # toggle an existing split's direction, so w>tab is intentionally omitted.
          "vim/ctrl+h=goto_split:left"
          "vim/ctrl+l=goto_split:right"
          "vim/w>s=new_split:right"
          "vim/w>shift+s=new_split:down"
          "vim/w>d=close_surface"
        ];
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
