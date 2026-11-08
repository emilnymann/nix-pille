{inputs, ...}: {
  flake.homeModules.web-browser = {
    config,
    lib,
    osConfig ? {},
    pkgs,
    ...
  }: let
    program = config.features.web-browser.program;
    hyprlandEnabled = lib.attrByPath ["programs" "hyprland" "enable"] false osConfig;
  in {
    imports = [inputs.glide.homeModules.default];

    options.features.web-browser = {
      program = lib.mkOption {
        type = lib.types.enum ["firefox" "glide"];
        default = "firefox";
        description = ''
          Browser implementation for this user.
          Firefox is the default. Set this to glide to keep the Glide config.
        '';
      };

      glide.extensionLines = lib.mkOption {
        type = lib.types.listOf lib.types.lines;
        default = [];
        description = ''
          Glide addon install lines. Written only when program is glide.
        '';
      };
    };

    config = lib.mkMerge [
      (lib.mkIf (program == "firefox") {
        programs.firefox.enable = true;

        wayland.windowManager.hyprland.settings = lib.mkIf hyprlandEnabled {
          browser._var = lib.getExe config.programs.firefox.finalPackage;
        };
      })

      (lib.mkIf (program == "glide") {
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

        wayland.windowManager.hyprland.settings = lib.mkIf hyprlandEnabled {
          browser._var = lib.getExe config.programs.glide-browser.package;
        };
      })
    ];
  };
}
