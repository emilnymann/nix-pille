_: {
  flake.nixosModules.smart-shell = _: {
    programs.fish.enable = true;
  };

  flake.homeModules.smart-shell = {pkgs, ...}: {
    home.packages = with pkgs; [
      fishPlugins.pure
    ];

    programs = {
      fish = {
        enable = true;
        interactiveShellInit = "set fish_greeting";
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      zellij = {
        enable = true;
        enableFishIntegration = true;
        attachExistingSession = true;
        settings = {
          default_mode = "locked";
        };
        extraConfig = ''
          keybinds {
            normal {
              bind "p" { SwitchToMode "Pane"; }
              bind "n" { SwitchToMode "Resize"; }
              bind "s" { SwitchToMode "Scroll"; }
              bind "o" { SwitchToMode "Session"; }
              bind "t" { SwitchToMode "Tab"; }
              bind "h" { SwitchToMode "Move"; }
              bind "q" { Quit; }

              bind "H" { GoToPreviousTab; }
              bind "L" { GoToNextTab; }

              bind "Ctrl h" { MoveFocus "Left"; }
              bind "Ctrl j" { MoveFocus "Down"; }
              bind "Ctrl k" { MoveFocus "Up"; }
              bind "Ctrl l" { MoveFocus "Right"; }
            }
          }
        '';
      };
    };
  };
}
