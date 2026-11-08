{inputs, ...}: {
  flake-file.inputs.bitwarden-firefox-addon = {
    url = "file+https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
    flake = false;
  };

  flake.homeModules.bitwarden = {config, lib, pkgs, ...}: let
    program = config.features.web-browser.program;
    addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    firefoxId = "{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";
    src = inputs.bitwarden-firefox-addon;
    bitwarden = pkgs.stdenvNoCC.mkDerivation {
      pname = "bitwarden-firefox-addon";
      version = "latest";

      inherit src;
      dontUnpack = true;

      installPhase = ''
        runHook preInstall
        dest="$out/share/mozilla/extensions/${firefoxId}/${addonId}.xpi"
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
        runHook postInstall
      '';

      passthru.addonId = addonId;
    };
  in {
    features.web-browser.glide.extensionLines = lib.mkIf (program == "glide") [
      "glide.addons.install('file://${bitwarden}/share/mozilla/extensions/${firefoxId}/${addonId}.xpi', { force: true, private_browsing_allowed: true });"
    ];

    programs.firefox.globalExtensions = lib.mkIf (program == "firefox") [
      {
        package = bitwarden;
        settings.private_browsing = true;
      }
    ];
  };
}
