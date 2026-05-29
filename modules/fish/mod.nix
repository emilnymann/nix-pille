{ flake.nixosModules.fish = { pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  environment.systemPackages = with pkgs; [
    fzf
    fishPlugins.fzf-fish
    fishPlugins.pure
  ];

  users.users.ens = {
    shell = pkgs.fish;
  };
}; }
