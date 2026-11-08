{self, ...}: {
  flake.homeModules.ens-base = {pkgs, ...}: {
    imports = with self.homeModules; [
      neovim-ide
      version-control
      smart-shell
      coding-agent
      coding-agent-cursor
      password-manager
      music-player
      nix-helper
    ];

    programs.git.settings = {
      user = {
        name = "Emil Nymann Sølyst";
        email = "emilnymann96@gmail.com";
        signingkey = "45E51048D62204CCD70B633B31D710749D7D8E7B";
      };
      commit.gpgsign = true;
      tag.gpgsign = true;
    };

    programs.jujutsu.settings = {
      user = {
        name = "Emil Nymann Sølyst";
        email = "emilnymann96@gmail.com";
      };
    };

    features.web-browser.program = "glide";

    stylix = {
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
      fonts = {
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
    };

    programs.nixvim.colorschemes.gruvbox-material = {
      enable = true;
      autoLoad = true;
    };

    xdg.enable = true;
    home.stateVersion = "26.05";
  };
}
