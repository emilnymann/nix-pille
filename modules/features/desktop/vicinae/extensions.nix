_: {
  flake.homeModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      sovereignExts =
        pkgs.fetchFromGitHub {
          owner = "vicinaehq";
          repo = "extensions";
          rev = "b2169756872919f2bdeece9bce47247ba5d99b8a";
          sha256 = "sha256-9D3/tZiIUUqNEVs0zdEgdTkY6qS70qbV87+KrXWiwV4=";
        }
        + "/extensions";
    in
    lib.mkIf config.programs.vicinae.enable {
      programs.vicinae.extensions = [
        (config.lib.vicinae.mkExtension {
          name = "hypr-keybinds";
          npmDepsHash = "sha256-5M5D004jL90F2mN7BIKlEG8KD2nYuy/NkD7Hu8lBBu0=";
          src = sovereignExts + "/hypr-keybinds";
        })
        (config.lib.vicinae.mkExtension {
          name = "nix";
          npmDepsHash = "sha256-HPWNUznCWVPz39PlPEBR7GpgbC0DuIAvVBdB2GAs47A=";
          src = sovereignExts + "/nix";
        })
      ];
    };
}
