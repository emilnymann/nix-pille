_: {
  flake.nixosModules.gaming = {pkgs, ...}: {
    programs = {
      steam = {
        enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      gamemode = {
        enable = true;
      };
    };

    hardware.xpadneo = {
      enable = true;
      settings = {
        disable_deadzones = 1;
        disable_shift_mode = 1;
      };
    };
  };
}
