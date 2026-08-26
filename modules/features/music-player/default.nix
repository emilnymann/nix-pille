_: {
  flake.homeModules.music-player = {pkgs, ...}: let
    tomlFormat = pkgs.formats.toml {};
    settings = {
      volume = 1;
      volume_min = -50;
      repeat = "off";
      shuffle = true;
      eq_preset = "Flat";
    };
  in {
    home.packages = with pkgs; [cliamp];

    xdg.configFile."cliamp/config.toml" = {
      force = true;
      source = tomlFormat.generate "cliamp-config.toml" settings;
    };
  };
}
