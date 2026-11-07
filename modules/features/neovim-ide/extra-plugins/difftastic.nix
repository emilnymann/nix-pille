{
  inputs,
  self,
  ...
}: {
  flake-file.inputs.difftastic-nvim = {
    url = "github:clabby/difftastic.nvim";
    flake = false;
  };

  perSystem = {pkgs, ...}: let
    src = inputs.difftastic-nvim;
    version = let
      d = inputs.difftastic-nvim.lastModifiedDate;
    in "0-unstable-${pkgs.lib.substring 0 4 d}-${pkgs.lib.substring 4 2 d}-${pkgs.lib.substring 6 2 d}";
    libExt =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "dylib"
      else "so";

    difftastic-nvim-lib = pkgs.rustPlatform.buildRustPackage {
      pname = "difftastic-nvim-lib";
      inherit src version;

      cargoLock.lockFile = src + "/Cargo.lock";

      nativeBuildInputs = [pkgs.pkg-config];
      buildInputs = [pkgs.luajit];

      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib
        find target -path '*release*' -name "libdifftastic_nvim.${libExt}" -exec cp {} $out/lib/ \;
        runHook postInstall
      '';
    };
  in {
    packages.difftastic-nvim = pkgs.vimUtils.buildVimPlugin {
      pname = "difftastic";
      inherit src version;

      dependencies = [pkgs.vimPlugins.nui-nvim];

      postInstall = ''
        mkdir -p $out/target/release
        ln -s ${difftastic-nvim-lib}/lib/libdifftastic_nvim.${libExt} $out/target/release/libdifftastic_nvim.${libExt}
        ln -s ${difftastic-nvim-lib}/lib/libdifftastic_nvim.${libExt} $out/target/release/difftastic_nvim.so
      '';
    };
  };

  flake.homeModules.neovim-ide = _: {
    programs.nixvim.imports = [
      ({
        lib,
        pkgs,
        ...
      }:
        inputs.nixvim.lib.nixvim.plugins.mkNeovimPlugin {
          name = "difftastic";
          moduleName = "difftastic-nvim";

          package = lib.mkOption {
            type = lib.types.package;
            default = self.packages.${pkgs.stdenv.hostPlatform.system}.difftastic-nvim;
          };

          maintainers = [];

          settingsExample = {
            download = false;
            vcs = "jj";
          };
        })
    ];
  };
}
