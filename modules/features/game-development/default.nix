_: {
  flake.nixosModules = {
    gamedev = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        blender
      ];
    };

    gamedev-lowpoly-modeling = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        blockbench
      ];
    };
  };
}
