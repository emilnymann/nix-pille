_: {
  flake.homeModules.clipboard =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wl-clipboard
      ];

      programs.nixvim.clipboard.wl-copy.enable = true;
    };
}
