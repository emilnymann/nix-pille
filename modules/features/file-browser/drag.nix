_: {
  flake.homeModules.file-browser =
    {
      osConfig,
      lib,
      pkgs,
      ...
    }:
    lib.mkIf osConfig.programs.hyprland.enable {
      programs.yazi = {
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
    };
}
