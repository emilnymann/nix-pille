local root = vim.fs.root(0, { "flake.nix", ".git" }) or vim.uv.cwd()

local function from_flake(expr)
  return string.format(
    [[
let
  flake = builtins.getFlake %q;
in
%s
]],
    root,
    expr
  )
end

local function merge_config_options(attr)
  return from_flake(string.format(
    [[
let
  lib = flake.inputs.nixpkgs.lib;
in
lib.foldl' lib.recursiveUpdate { }
  (map (cfg: cfg.options) (builtins.attrValues flake.%s))
]],
    attr
  ))
end

local function merge_home_manager_options()
  return from_flake([[
let
  lib = flake.inputs.nixpkgs.lib;
  merge = configs:
    lib.foldl' lib.recursiveUpdate { }
      (map
        (cfg: cfg.options.home-manager.users.type.getSubOptions [])
        (builtins.attrValues configs));
in
lib.recursiveUpdate
  (merge flake.nixosConfigurations)
  (merge flake.darwinConfigurations)
]])
end

local function nixvim_options()
  return from_flake([[
let
  system = builtins.currentSystem;
  cfg = flake.inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import flake.inputs.nixpkgs { inherit system; };
    modules = [
      flake.inputs.nixvim.homeModules.nixvim
      flake.homeModules.neovim-ide
      {
        home.username = "nixd";
        home.homeDirectory = "/tmp";
        home.stateVersion = "26.05";
      }
    ];
  };
in
cfg.options.programs.nixvim.type.getSubOptions []
]])
end

vim.lsp.config("nixd", {
  settings = {
    nixd = {
      nixpkgs = {
        expr = from_flake("import flake.inputs.nixpkgs { }"),
      },
      options = {
        nixos = {
          expr = merge_config_options("nixosConfigurations"),
        },
        ["nix-darwin"] = {
          expr = merge_config_options("darwinConfigurations"),
        },
        ["home-manager"] = {
          expr = merge_home_manager_options(),
        },
        nixvim = {
          expr = nixvim_options(),
        },
        ["flake-parts"] = {
          expr = from_flake("flake.debug.options"),
        },
      },
    },
  },
})
