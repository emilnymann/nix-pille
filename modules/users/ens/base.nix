{self, ...}: {
  flake.homeModules.ens-base = {
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
    features.theming.colorscheme = "gruvbox-material-dark-medium";

    programs.ghostty = {
      clearDefaultKeybinds = true;
      settings.keybind = [
        "super+c=copy_to_clipboard"
        "super+v=paste_from_clipboard"

        "vim/"
        "ctrl+g=activate_key_table:vim"
        "vim/ctrl+g=deactivate_key_table"

        "vim/shift+h=previous_tab"
        "vim/shift+l=next_tab"
        "vim/t>n=new_tab"
        "vim/t>d=close_tab"

        "vim/ctrl+h=goto_split:left"
        "vim/ctrl+l=goto_split:right"
        "vim/w>s=new_split:right"
        "vim/w>shift+s=new_split:down"
        "vim/w>d=close_surface"
      ];
    };

    xdg.enable = true;
    home.stateVersion = "26.05";
  };
}
