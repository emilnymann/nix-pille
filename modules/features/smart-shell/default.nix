_: {
  flake.nixosModules.smart-shell = _: {
    programs.fish.enable = true;
  };

  flake.homeModules.smart-shell = {pkgs, ...}: {
    home.packages = with pkgs; [
      fishPlugins.pure
    ];

    programs = {
      fish = {
        enable = true;
        interactiveShellInit = "set fish_greeting";
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      direnv = {
        enable = true;
        enableFishIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
