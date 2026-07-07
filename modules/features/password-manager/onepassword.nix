_: {
  flake.homeModules.onepassword = _: {
    features.web-browser.glide.extensionLines = [
      "glide.addons.install('https://addons.mozilla.org/firefox/downloads/file/4853670/1password_x_password_manager-8.12.24.34.xpi', { force: true, private_browsing_allowed: true });"
    ];
  };
}
