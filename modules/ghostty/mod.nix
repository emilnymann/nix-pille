{ flake.nixosModules.ghostty = { pkgs, ... }: {
  environment.systemPackages = with pkgs; [ ghostty ];

  hjem.users.ens = {
    files.".config/ghostty/config.ghostty".text = ''
      theme = Gruvbox Dark
      window-padding-x = 16
      window-padding-y = 16
    '';
  };
}; }
