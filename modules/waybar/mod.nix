{ flake.nixosModules.waybar = { pkgs, ... }: {
  fonts.packages = with pkgs; [
    font-awesome_4
  ];

  programs.waybar = {
    enable = true;
  };
}; }
