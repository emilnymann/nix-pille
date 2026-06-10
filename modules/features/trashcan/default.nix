_: {
  flake.nixosModules.trashcan =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        trash-cli
      ];
    };
}
