_: {
  flake.homeModules.bitwarden = {config, lib, pkgs, ...}: let
    program = config.features.web-browser.program;
    addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    firefoxId = "{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";
    bitwarden = pkgs.stdenvNoCC.mkDerivation {
      pname = "bitwarden-firefox-addon";
      version = "2026.5.0";

      src = pkgs.fetchurl {
        url = "https://addons.mozilla.org/firefox/downloads/file/4827854/bitwarden_password_manager-2026.5.0.xpi";
        hash = "sha256-jrtHVRijMLiLTiy6CGTFyhG+05BznLhPvyVuk4yRttk=";
      };

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
      "glide.addons.install('https://addons.mozilla.org/firefox/downloads/file/4827854/bitwarden_password_manager-2026.5.0.xpi', { force: true, private_browsing_allowed: true });"
    ];

    programs.firefox.globalExtensions = lib.mkIf (program == "firefox") [
      {
        package = bitwarden;
        settings.private_browsing = true;
      }
    ];
  };
}
