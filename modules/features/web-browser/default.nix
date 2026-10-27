{inputs, ...}: {
  flake.homeModules.web-browser = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.glide.homeModules.default];

    options.features.web-browser.glide.extensionLines = lib.mkOption {
      type = lib.types.listOf lib.types.lines;
      default = [];
    };

    config = {
      xdg.configFile."glide/glide.ts".source = ./glide/glide.ts;
      xdg.configFile."glide/extensions.glide.ts".text =
        lib.concatStringsSep "\n" config.features.web-browser.glide.extensionLines;

      programs.glide-browser = {
        enable = true;
        package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
          pkgs.wrapFirefox
          (
            (inputs.glide.packages.${pkgs.stdenv.hostPlatform.system}.glide-browser-bin-unwrapped.override {
              inherit (config.programs.glide-browser) policies;
            }).overrideAttrs (oldAttrs: {
              nativeBuildInputs =
                (oldAttrs.nativeBuildInputs or [])
                ++ [pkgs.darwin.autoSignDarwinBinariesHook];
            })
          )
          {
            pname = "glide-browser-bin";
          }
        );
      };

      wayland.windowManager.hyprland.settings = {
        browser = {
          _var = lib.getExe config.programs.glide-browser.package;
        };
      };
    };
  };
}
