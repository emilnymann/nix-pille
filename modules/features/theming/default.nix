{inputs, ...}: let
  colorschemes = {
    gruvbox-material-dark-medium = {
      polarity = "dark";
      file = "gruvbox-material-dark-medium.yaml";
      nixvim = "gruvbox-material";
    };
  };

  colorschemeOption = lib:
    lib.mkOption {
      type = lib.types.enum (builtins.attrNames colorschemes);
      description = ''
        Named color theme.
        Sets Stylix polarity and the base16 scheme.
        The home module also sets the font stack and the matching nixvim colorscheme.
      '';
    };

  fonts = pkgs: {
    monospace = {
      package = pkgs.maple-mono.NF;
      name = "Maple Mono NF";
    };
    serif = {
      package = pkgs.nerd-fonts.noto;
      name = "NotoSerif Nerd Font";
    };
    sansSerif = {
      package = pkgs.nerd-fonts.noto;
      name = "NotoSans Nerd Font";
    };
    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };
in {
  flake-file.inputs.breezex-dark = {
    url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Dark.tar.xz";
    flake = false;
  };

  flake.nixosModules.theming = {
    config,
    lib,
    pkgs,
    ...
  }: let
    theme = colorschemes.${config.features.theming.colorscheme};
  in {
    imports = [inputs.stylix.nixosModules.stylix];

    options.features.theming.colorscheme = colorschemeOption lib;

    config.stylix = {
      enable = true;
      polarity = theme.polarity;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme.file}";
      homeManagerIntegration.autoImport = false;
      targets.kmscon.enable = false;
    };
  };

  flake.darwinModules.theming = {
    imports = [inputs.stylix.darwinModules.stylix];
  };

  flake.homeModules.theming = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.features.theming;
    theme = colorschemes.${cfg.colorscheme};
    nixvimEnabled = lib.attrByPath ["programs" "nixvim" "enable"] false config;
    cursorSources = {
      BreezeX-Dark = inputs.breezex-dark;
    };
  in {
    imports = [inputs.stylix.homeModules.stylix];

    options.features.theming = {
      colorscheme = colorschemeOption lib;

      cursor = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum (builtins.attrNames cursorSources));
        default = null;
        description = ''
          Linux cursor theme. Leave this unset on Darwin.
          The theme archive is the breezex-dark flake input.
        '';
      };

      cursorSize = lib.mkOption {
        type = lib.types.ints.positive;
        default = 24;
        description = "Cursor size in pixels. Used only when cursor is set.";
      };
    };

    config = {
      stylix = {
        enable = true;
        overlays.enable = false;
        polarity = theme.polarity;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme.file}";
        fonts = fonts pkgs;
      };

      programs.nixvim.colorschemes.${theme.nixvim} = lib.mkIf nixvimEnabled {
        enable = true;
        autoLoad = true;
      };

      home.pointerCursor = lib.mkIf (cfg.cursor != null && pkgs.stdenv.hostPlatform.isLinux) {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        name = cfg.cursor;
        size = cfg.cursorSize;
        package = pkgs.runCommand "moveUp" {} ''
          mkdir -p $out/share/icons
          ln -s ${cursorSources.${cfg.cursor}} $out/share/icons/${cfg.cursor}
        '';
      };
    };
  };
}
