{inputs, ...}: {
  flake-file.inputs.hyprmac = {
    url = "github:emilnymann/HyprMac-contrib/push-lzoqlxmrokyr";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.homeModules.hyprmac = {
    config,
    lib,
    pkgs,
    ...
  }: let
    browserBundleId =
      if config.features.web-browser.program == "glide"
      then "app.glide-browser.glide"
      else "org.mozilla.firefox";

    term = {inherit (config.features.terminal-emulator) bin titleFlag execFlag;};
    yaziCmd = "${term.bin} ${term.titleFlag}yazi ${term.execFlag} ${lib.getExe config.programs.yazi.finalPackage}";

    # Modifier bitmask: 1 = Hypr, 2 = Shift, 4 = Option, 8 = Control, 16 = Command.
    # Carbon kVK_* codes: H=4, J=38, K=40, L=37, Return=36, B=11, F=3, O=31, /=44.
    hjklDirections = [
      {
        keyCode = 4;
        dir = "left";
      }
      {
        keyCode = 38;
        dir = "down";
      }
      {
        keyCode = 40;
        dir = "up";
      }
      {
        keyCode = 37;
        dir = "right";
      }
    ];
  in {
    imports = [inputs.hyprmac.homeManagerModules.default];

    programs.hyprmac = {
      enable = true;
      launchd.enable = true;

      settings = {
        hyprKey = "leftCommand";
        gapSize = 6;
        outerPadding = 6;
        focusFollowsMouse = true;
        overlayAppearance = "dark";
        overlayAccentHex = "d8a657";
        focusBorderColorHex = "7daea3";
        floatingBorderColorHex = "d3869b";
        focusBracketColorHex = "d8a657";
        focusBracketStyle = "off";
        showFocusBorder = true;

        excludedBundleIDs = [
          "com.apple.FaceTime"
          "com.apple.systempreferences"
          "com.1password.1password"
          "pl.maketheweb.cleanshotx"
        ];

        keybinds =
          (lib.concatMap (
              {
                keyCode,
                dir,
              }: [
                # Hypr + H/J/K/L -> focus direction
                {
                  inherit keyCode;
                  modifiers = 1;
                  action.focusDirection._0 = dir;
                }
                # Hypr + Shift + H/J/K/L -> swap direction
                {
                  inherit keyCode;
                  modifiers = 3;
                  action.swapDirection._0 = dir;
                }
                # Hypr + Ctrl + H/J/K/L -> move window to monitor
                {
                  inherit keyCode;
                  modifiers = 9;
                  action.moveWorkspaceToMonitor._0 = dir;
                }
                # Hypr + Ctrl + Shift + H/J/K/L -> resize direction
                {
                  inherit keyCode;
                  modifiers = 11;
                  action.resizeDirection._0 = dir;
                }
              ]
            )
            hjklDirections)
          ++ [
            # Hypr + Return -> Ghostty
            {
              keyCode = 36;
              modifiers = 1;
              action.launchApp.bundleID = "com.mitchellh.ghostty";
            }
            # Hypr + Shift + B -> Browser (Glide / Firefox)
            {
              keyCode = 11;
              modifiers = 3;
              action.launchApp.bundleID = browserBundleId;
            }
            # Hypr + Shift + F -> Yazi in Ghostty
            {
              keyCode = 3;
              modifiers = 3;
              action.runCommand = {
                label = "File manager";
                command = yaziCmd;
              };
            }
            # Hypr + / -> Toggle split direction (since Hypr + J is focus down)
            {
              keyCode = 44;
              modifiers = 1;
              action.toggleSplit = {};
            }
            # Hypr + Opt + K -> Show keybind overlay (since Hypr + K is focus up)
            {
              keyCode = 40;
              modifiers = 5;
              action.showKeybinds = {};
            }
          ];
      };

      monitorSettings = {
        externalControlEnabled = true;
      };
    };
  };
}
