_: {
  flake.homeModules.file-browser =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      withHyprland = config.wayland.windowManager.hyprland.enable;
      term = { inherit (config.features.terminal-emulator) bin titleFlag execFlag; };
    in
    {
      programs.yazi = {
        enable = true;

        extraPackages = with pkgs; [
          ripdrag
        ];

        plugins = {
          drag = pkgs.yaziPlugins.drag;
        };

        keymap.mgr.prepend_keymap = [
          {
            on = [ "<C-d>" ];
            run = "plugin drag";
            desc = "Drag Files";
          }
        ];
      };

      wayland.windowManager.hyprland.settings = lib.mkIf withHyprland {
        filemanager = {
          _var = "${term.bin} ${term.titleFlag}yazi ${term.execFlag} ${pkgs.yazi}/bin/yazi";
        };
      };
    };
}
