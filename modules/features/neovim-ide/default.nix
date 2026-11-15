{inputs, ...}: {
  flake.homeModules.neovim-ide = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.nixvim.homeModules.nixvim];

    # create nvim cache dir on home-manager activation, after
    # DAG (directed acyclic graph) write boundary, so after HM finishes
    # writing managed files and symlinks.
    home.activation.createNvimCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "${config.xdg.cacheHome}/nvim"
    '';

    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      nixpkgs.config.allowUnfree = true;
    };
  };
}
