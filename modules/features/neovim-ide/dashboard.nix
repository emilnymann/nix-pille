_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      dependencies.ripgrep.enable = true;
      plugins = {
        snacks = {
          enable = true;
          settings = {
            dashboard = {
              enabled = true;
              preset = {
                header = ''
                  @@@  @@@  @@@  @@@  @@@  @@@  @@@  @@@  @@@@@@@@@@!
                  @@@@ @@@  @@@  @@@  @@@  @@@  @@@  @@@  @@@@@@@@@@@
                  @@!@!@@@  @@!  @@!  !@@  @@!  @@@  @@!  @@! @@! @@!
                  !@!!@!@!  !@!  !@!  @!!  !@!  @!@  !@!  !@! !@! !@!
                  @!@ !!@!  !!@   !@@!@!   @!@  !@!  !!@  @!! !!@ @!@
                  !@!  !!!  !!!    @!!!    !@!  !!!  !!!  !@!   ! !@!
                  !!:  !!!  !!:   !: :!!   :!:  !!:  !!:  !!:     !!:
                  :!:  !:!  :!:  :!:  !:!   ::!!:!   :!:  :!:     :!:
                  ::   ::   ::   ::  :::    ::::     ::  :::     ::
                  ::    :   :     :   ::      :      :     :      :
                '';
                keys = [
                  {
                    icon = " ";
                    key = "f";
                    desc = "Find File";
                    action = ":lua Snacks.dashboard.pick('files')";
                  }
                  {
                    icon = " ";
                    key = "n";
                    desc = "New File";
                    action = ":ene | startinsert";
                  }
                  {
                    icon = " ";
                    key = "g";
                    desc = "Live Grep";
                    action = ":lua Snacks.dashboard.pick('live_grep')";
                  }
                  {
                    icon = " ";
                    key = "d";
                    desc = "Todo";
                    action = ":DooingLocal";
                  }
                  {
                    icon = " ";
                    key = "r";
                    desc = "Recent Files";
                    action = ":lua Snacks.dashboard.pick('oldfiles')";
                  }
                  {
                    icon = "󰙰 ";
                    key = "R";
                    desc = "Restore Session";
                    action.__raw = ''function() require("persistence").load() end'';
                  }
                  {
                    icon = " ";
                    key = "q";
                    desc = "Quit";
                    action = ":qa";
                  }
                ];
              };
              sections = [
                {section = "header";}
                {
                  section = "keys";
                  gap = 1;
                  padding = 1;
                }
              ];
            };
          };
        };

        lualine = {
          settings = {
            options = {
              disabled_filetypes = ["snacks_dashboard"];
            };
          };
        };
      };
    };
  };
}
