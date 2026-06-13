_: {
  flake.homeModules.coding-agent = {pkgs, ...}: {
    programs.pi-coding-agent = {
      enable = true;
      extraPackages = [pkgs.nodejs];
    };
  };
}
