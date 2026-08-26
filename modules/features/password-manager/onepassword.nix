_: {
  flake.homeModules.onepassword = _: {
    features.web-browser.glide.extensionLines = [
      # Reinstalling on every config load can interrupt 1Password's extension database.
      "glide.addons.install('https://addons.mozilla.org/firefox/downloads/file/4853670/1password_x_password_manager-8.12.32.33.xpi', { private_browsing_allowed: true });"
    ];
  };
}
