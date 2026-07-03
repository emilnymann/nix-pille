_: {
  flake.homeModules.web-browser =
    {
      config,
      lib,
      ...
    }:
    let
      withHyprland = config.wayland.windowManager.hyprland.enable;
    in
    {
      options.features.web-browser.glide.extensionLines = lib.mkOption {
        type = lib.types.listOf lib.types.lines;
        default = [ ];
      };

      config = {
        xdg.configFile."glide/glide.ts".source = ./glide/glide.ts;
        xdg.configFile."glide/extensions.glide.ts".text =
          lib.concatStringsSep "\n" config.features.web-browser.glide.extensionLines;

        programs.glide-browser = {
          enable = true;
          profiles.${config.home.username} = {
            isDefault = true;
            name = config.home.username;
          };
        };

        wayland.windowManager.hyprland.settings = lib.mkIf withHyprland {
          browser = {
            _var = lib.getExe config.programs.glide-browser.package;
          };
        };
      };
    };
}
