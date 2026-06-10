_: {
  flake.nixosModules.bluetooth = _: {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };

  flake.homeModules.bluetooth =
    {
      pkgs,
      osConfig,
      lib,
      ...
    }:
    lib.mkIf osConfig.hardware.bluetooth.enable {
      home.packages = with pkgs; [
        bluetui
      ];

      xdg.desktopEntries = {
        bluetui = {
          categories = [
            "System"
            "Settings"
            "Network"
          ];
          exec = "${lib.getExe pkgs.bluetui}";
          genericName = "Bluetooth Settings";
          name = "Bluetui";
          terminal = true;
        };
      };
    };
}
