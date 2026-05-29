{ self, inputs, ... }:
{
  flake.nixosModules.cursor-theme =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      environment.systemPackages =
        with pkgs;
        lib.optionals config.programs.hyprland.enable [
          hyprcursor
        ];
    };

  flake.homeModules.cursor-theme.rose-pine =
    {
      self,
      lib,
      pkgs,
      osConfig,
      ...
    }:
    {
      packages =
        with pkgs;
        [
          rose-pine-cursor
        ]
        ++ lib.optionals osConfig.programs.hyprland.enable [
          rose-pine-hyprcursor
        ];

      homeModules.gtk-conf = {
        settings3.Settings = {
          gtk-cursor-theme-name = "BreezeX-RosePine-Linux";
          gtk-cursor-theme-size = 24;
        };

        settings4.Settings = {
          gtk-cursor-theme-name = "BreezeX-RosePine-Linux";
          gtk-cursor-theme-size = 24;
        };
      };

      xdg.config.files = {
        "environment.d/cursor-theme.conf" = {
          generator = lib.generators.toKeyValue { };
          value = {
            XCURSOR_THEME = "BreezeX-RosePine-Linux";
            XCURSOR_SIZE = 24;
          }
          // lib.optionalAttrs osConfig.programs.hyprland.enable {
            HYPRCURSOR_THEME = "rose-pine-hyprcursor";
            HYPRCURSOR_SIZE = 24;
          };
        };
      };
    };
}
