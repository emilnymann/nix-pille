{inputs, ...}: {
  flake-file.inputs.onepassword-firefox-addon = {
    url = "file+https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
    flake = false;
  };

  flake.homeModules.onepassword = {config, lib, pkgs, ...}: let
    program = config.features.web-browser.program;
    addonId = "{d634138d-c276-4fc8-924b-40a0ea21d284}";
    firefoxId = "{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";
    src = inputs.onepassword-firefox-addon;
    onepassword = pkgs.stdenvNoCC.mkDerivation {
      pname = "onepassword-firefox-addon";
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
      # Reinstalling on every config load can interrupt 1Password's extension database.
      "glide.addons.install('file://${onepassword}/share/mozilla/extensions/${firefoxId}/${addonId}.xpi', { private_browsing_allowed: true });"
    ];

    programs.firefox.globalExtensions = lib.mkIf (program == "firefox") [
      {
        package = onepassword;
        settings.private_browsing = true;
      }
    ];
  };
}
