{
  inputs,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages = pkgs.lib.optionalAttrs (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
      dlsslop-amd = pkgs.callPackage ../../../pkgs/dlsslop-amd.nix {
        src = inputs.dlsslop-amd;
      };
    };
  };

  flake.nixosModules.gaming = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.features.gaming.dlsslop-amd.enable = lib.mkEnableOption ''
      the experimental DLSSLOP AMD neural Vulkan layer and its command-line tools
      (requires an RX 9070 XT / gfx1201 GPU, compatible HIP runtime, and separately
      acquired model weights)
    '';

    config = {
      programs = {
        steam = {
          enable = true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
        };

        gamemode.enable = true;
      };

      hardware.xpadneo = {
        enable = true;
        settings = {
          disable_deadzones = 1;
          disable_shift_mode = 1;
        };
      };

      features.gaming.dlsslop-amd.enable = true;

      environment.systemPackages = [
        pkgs.bottles
      ] ++ lib.optionals config.features.gaming.dlsslop-amd.enable [
        self.packages.${pkgs.stdenv.hostPlatform.system}.dlsslop-amd
      ];
    };
  };
}
