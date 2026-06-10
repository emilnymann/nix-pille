_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.snacks = {
        enable = true;
        settings = {
          dashboard = {
            enabled = true;
            preset = {
              header = ''
                @@@  @@@  @@@  @@@  @@@  @@@  @@@  @@@  @@@@@@@@@@ 
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
                  desc = "Find Text";
                  action = ":lua Snacks.dashboard.pick('live_grep')";
                }
                {
                  icon = " ";
                  key = "r";
                  desc = "Recent Files";
                  action = ":lua Snacks.dashboard.pick('old_files')";
                }
                {
                  icon = " ";
                  key = "c";
                  desc = "Config";
                  action = ":lua Snacks.dashboard.pick('files', { cwd = '/etc/nixos/modules/features/neovim-ide'})";
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
              { section = "header"; }
              {
                section = "keys";
                gap = 1;
                padding = 1;
              }
            ];
          };
        };
      };
    };
  };
}
