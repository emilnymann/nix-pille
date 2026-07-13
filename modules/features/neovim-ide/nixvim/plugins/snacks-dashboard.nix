_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      dependencies.ripgrep.enable = true;
      plugins.snacks = {
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
                  key = "s";
                  desc = "Find Text";
                  action = ":lua Snacks.dashboard.pick('live_grep')";
                }
                {
                  icon = " ";
                  key = "r";
                  desc = "Recent Files";
                  action = ":lua Snacks.dashboard.pick('oldfiles')";
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
              {section = "header";}
              {
                section = "keys";
                gap = 1;
                padding = 1;
              }
              {
                icon = " ";
                title = "Git";
                key = "g";
                action.__raw = "function() Snacks.lazygit() end";
                section = "terminal";
                enabled.__raw = "function() return Snacks.git.get_root() ~= nil end";
                cmd = "git status --short --branch --renames";
                height = 8;
                padding = 1;
                ttl = 300;
                indent = 2;
              }
            ];
          };
        };
      };
    };
  };
}
