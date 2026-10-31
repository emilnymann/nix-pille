{self, ...}: {
  perSystem = {pkgs, ...}: {
    packages = pkgs.lib.optionalAttrs (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
      quadcast-rgb = pkgs.callPackage ../../../pkgs/quadcast-rgb {};
    };
  };

  flake.nixosModules.quadcast-rgb = {pkgs, ...}: let
    # Source lives in pkgs/quadcast-rgb (see src/main.rs for protocol notes).
    #
    # The mic's LED controller renders a host-fed frame stream; without one
    # it falls back to its built-in demo (the rainbow/blink loop). Saving to
    # flash works but only holds a ~40-frame boot region, so a static color
    # needs a small stream daemon: `quadcast-rgb stream` sends one 64-byte
    # control packet every 55 ms.
    quadcast-rgb = self.packages.${pkgs.stdenv.hostPlatform.system}.quadcast-rgb;

    # The color the mic shows while connected (change + rebuild to taste).
    color = "fe8019"; # gruvbox orange
  in {
    environment.systemPackages = [quadcast-rgb];

    # - uaccess: let the session user run quadcast-rgb without sudo.
    # - systemd tag + SYSTEMD_WANTS: auto-start the stream service when the
    #   mic's RGB function is plugged in.
    services.udev.extraRules = ''
      ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="0951", ATTR{idProduct}=="171f", TAG+="uaccess", TAG+="systemd", ENV{SYSTEMD_WANTS}="quadcast-rgb.service"
    '';

    systemd.services.quadcast-rgb = {
      description = "HyperX QuadCast S static RGB stream";
      # Not wanted by any boot target: udev starts it on plug, and the tool
      # exits cleanly when the mic is unplugged.
      serviceConfig = {
        ExecStart = "${pkgs.lib.getExe quadcast-rgb} stream ${color}";
        Restart = "on-failure";
        RestartSec = 2;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
      };
    };
  };
}
