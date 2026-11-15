_: {
  flake.homeModules.coding-agent = {pkgs, ...}: {
    programs.pi-coding-agent = {
      enable = true;
      extraPackages = with pkgs; [
        nodejs
        ast-grep
        rtk
        ffmpeg
      ];
    };
  };
}
