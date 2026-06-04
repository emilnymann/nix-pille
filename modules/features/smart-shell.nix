_: {
  flake.nixosModules.smart-shell = _: {
    programs.fish.enable = true;
  };

  flake.homeModules.smart-shell =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        fishPlugins.pure
      ];

      programs.fish = {
        enable = true;
        interactiveShellInit = "set fish_greeting";
        plugins = [
          {
            name = "pure";
            src = pkgs.fishPlugins.pure.src;
          }
        ];
      };
    };
}
