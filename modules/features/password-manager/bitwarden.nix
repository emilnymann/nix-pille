_: {
  flake.homeModules.bitwarden = _: {
    features.web-browser.glide.extensionLines = [
      "glide.addons.install('https://addons.mozilla.org/firefox/downloads/file/4827854/bitwarden_password_manager-2026.5.0.xpi', { force: true, private_browsing_allowed: true });"
    ];
  };
}
