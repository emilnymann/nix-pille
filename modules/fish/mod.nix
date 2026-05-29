{ flake.nixosModules.fish = { pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  environment.systemPackages = with pkgs; [
    zoxide
    fzf
    fishPlugins.fzf-fish
    fishPlugins.pure
  ];

  programs.zoxide.enableFishIntegration = true;

  users.users.ens = {
    shell = pkgs.fish;
  };
}; }
