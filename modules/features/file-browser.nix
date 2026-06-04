_: {
  flake.homeModules.file-browser =
    { pkgs, ... }:
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
    };
}
