# DO-NOT-EDIT. This file was auto-generated using github:denful/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "ENS NixOS flake";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree.filterNot (
        file:
        inputs.nixpkgs.lib.hasInfix "hardware-configuration" file
        || inputs.nixpkgs.lib.hasPrefix "_" (baseNameOf file)
      ) ./modules
    );

  inputs = {
    bitwarden-firefox-addon = {
      url = "file+https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      flake = false;
    };
    difftastic-nvim = {
      url = "github:clabby/difftastic.nvim";
      flake = false;
    };
    dlsslop-amd = {
      url = "github:imaami/dlsslop-amd/29ea4ace16985fdfb758b6c3cf9bad61f749d8cf";
      flake = false;
    };
    dooing = {
      url = "github:atiladefreitas/dooing";
      flake = false;
    };
    flake-file.url = "github:denful/flake-file";
    flake-parts.url = "github:hercules-ci/flake-parts";
    glide = {
      url = "github:glide-browser/glide.nix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixvim.url = "github:nix-community/nixvim";
    onepassword-firefox-addon = {
      url = "file+https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tuicr = {
      url = "github:xendarboh/tuicr.nvim";
      flake = false;
    };
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
  };
}
