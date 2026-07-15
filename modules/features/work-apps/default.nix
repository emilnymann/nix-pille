_: {
  flake.darwinModules."work-apps" = {pkgs, ...}: {
    system.defaults.CustomUserPreferences = {
      "com.linear" = {
        AutoUpdateDisabled = true;
      };
    };

    system.activationScripts.postActivation.text = ''
      install -d -m 755 "/Library/Managed Preferences"
      install -m 644 ${pkgs.writeText "com.tinyspeck.slackmacgap.plist" ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>AutoUpdate</key>
            <false/>
          </dict>
        </plist>
      ''} "/Library/Managed Preferences/com.tinyspeck.slackmacgap.plist"
      chown root:wheel "/Library/Managed Preferences/com.tinyspeck.slackmacgap.plist"
      /usr/bin/killall cfprefsd || true
    '';

    environment.systemPackages = with pkgs; [
      _1password-gui
      linear
      notion-app
      slack
    ];
  };
}
