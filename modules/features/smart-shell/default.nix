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

      zellij = {
        enable = true;
        enableFishIntegration = true;
        attachExistingSession = true;
        settings = {
          default_layout = "compact";
          default_mode = "locked";
        };
      };
    };
  };
}
