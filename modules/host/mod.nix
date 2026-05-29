{ inputs, config, ... }: {
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.hjem.nixosModules.default
      ../../hardware-configuration.nix
      config.flake.nixosModules.core
      config.flake.nixosModules.graphics
      config.flake.nixosModules.gpg
      config.flake.nixosModules.git
      config.flake.nixosModules.fish
      config.flake.nixosModules.hyprland
      config.flake.nixosModules.waybar
      config.flake.nixosModules.networking
      config.flake.nixosModules.users
      config.flake.nixosModules.bitwarden
      config.flake.nixosModules.ghostty
      config.flake.nixosModules.nvim
      config.flake.nixosModules.yazi
      config.flake.nixosModules.firefox
    ];
  };
}
