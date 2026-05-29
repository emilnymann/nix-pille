# TODO: set hyprland configs with lib.generators.toLua
_: {
  flake.nixosModules.wallpaper =
    { pkgs, lib, ... }:
    {
      options.features.desktop.wallpaper.enabled = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      config = {
        environment.systemPackages = with pkgs; [
          hyprpaper
          waytrogen
        ];
      };
    };

  # flake.homeModules.wallpaper =
  #   { lib, ... }:
  #   {
  #     config = {
  #       xdg.config.files = {
  #         "waytrogen/config.json" = {
  #           generator = lib.generators.toJSON { };
  #           value = {
  #
  #           };
  #         };
  #       };
  #     };
  #   };
}
