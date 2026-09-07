_: {
  flake.darwinModules."work-apps" = {config, pkgs, ...}: let
    slackNoAutoUpdateProfile = pkgs.writeTextFile {
      name = "slack-no-auto-update-profile";
      destination = "/share/slack-no-auto-update.mobileconfig";
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>PayloadContent</key>
            <array>
              <dict>
                <key>AutoUpdate</key>
                <false/>
                <key>PayloadDisplayName</key>
                <string>Slack Update Preferences</string>
                <key>PayloadIdentifier</key>
                <string>org.nix-darwin.slack-no-auto-update.preferences</string>
                <key>PayloadType</key>
                <string>com.tinyspeck.slackmacgap</string>
                <key>PayloadUUID</key>
                <string>039D389A-6817-4003-AEA9-E2BA93225B2D</string>
                <key>PayloadVersion</key>
                <integer>1</integer>
              </dict>
            </array>
            <key>PayloadDescription</key>
            <string>Disables Slack's built-in updater so Slack can be updated through Nix.</string>
            <key>PayloadDisplayName</key>
            <string>Disable Slack Automatic Updates</string>
            <key>PayloadIdentifier</key>
            <string>org.nix-darwin.slack-no-auto-update</string>
            <key>PayloadOrganization</key>
            <string>Nix</string>
            <key>PayloadRemovalDisallowed</key>
            <false/>
            <key>PayloadScope</key>
            <string>System</string>
            <key>PayloadType</key>
            <string>Configuration</string>
            <key>PayloadUUID</key>
            <string>23A0D975-C6E2-491E-8852-64FEEA176E83</string>
            <key>PayloadVersion</key>
            <integer>1</integer>
          </dict>
        </plist>
      '';
    };
    notionNoAutoUpdateProfile = pkgs.writeTextFile {
      name = "notion-no-auto-update-profile";
      destination = "/share/notion-no-auto-update.mobileconfig";
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>PayloadContent</key>
            <array>
              <dict>
                <key>NotionNoAutoUpdates</key>
                <true/>
                <key>PayloadDisplayName</key>
                <string>Notion Update Preferences</string>
                <key>PayloadIdentifier</key>
                <string>org.nix-darwin.notion-no-auto-update.preferences</string>
                <key>PayloadType</key>
                <string>notion.id</string>
                <key>PayloadUUID</key>
                <string>0F43E970-83C1-469C-9A2B-A2D91917755A</string>
                <key>PayloadVersion</key>
                <integer>1</integer>
              </dict>
            </array>
            <key>PayloadDescription</key>
            <string>Disables Notion's built-in updater so Notion can be updated through Nix.</string>
            <key>PayloadDisplayName</key>
            <string>Disable Notion Automatic Updates</string>
            <key>PayloadIdentifier</key>
            <string>org.nix-darwin.notion-no-auto-update</string>
            <key>PayloadOrganization</key>
            <string>Nix</string>
            <key>PayloadRemovalDisallowed</key>
            <false/>
            <key>PayloadScope</key>
            <string>System</string>
            <key>PayloadType</key>
            <string>Configuration</string>
            <key>PayloadUUID</key>
            <string>1A667B5B-440B-42C1-97E1-8A8CA7C46A32</string>
            <key>PayloadVersion</key>
            <integer>1</integer>
          </dict>
        </plist>
      '';
    };
  in {
    system.defaults.CustomUserPreferences = {
      "com.linear" = {
        AutoUpdateDisabled = true;
      };
      "dev.kdrag0n.MacVirt" = {
        SUEnableAutomaticChecks = false;
      };
    };

    home-manager.users.${config.system.primaryUser}.home.file = {
      "Documents/Nix/Profiles/slack-no-auto-update.mobileconfig".source = "${slackNoAutoUpdateProfile}/share/slack-no-auto-update.mobileconfig";
      "Documents/Nix/Profiles/notion-no-auto-update.mobileconfig".source = "${notionNoAutoUpdateProfile}/share/notion-no-auto-update.mobileconfig";
    };

    environment.systemPackages = with pkgs; [
      slackNoAutoUpdateProfile
      notionNoAutoUpdateProfile
      _1password-gui
      linear
      notion-app
      slack
      rainfrog
    ];
  };
}
