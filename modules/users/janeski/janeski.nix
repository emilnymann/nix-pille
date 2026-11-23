{
  self,
  inputs,
  ...
}: {
  flake = {
    homeConfigurations.janeski = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
      modules = [
        self.homeModules.janeski
        {
          home.username = "janeski";
          home.homeDirectory = "/home/janeski";
        }
      ];
    };

    homeModules.janeski = {
      config,
      osConfig,
      lib,
      pkgs,
      ...
    }: {
      imports = with self.homeModules; [
        desktop
        desktop-binds
        bluetooth
        file-browser
        web-browser
        terminal-emulator
        theming
        discord
        bitwarden
        neovim-ide
        version-control
        smart-shell
        password-manager
        music-player
        nix-helper
      ];

      programs.firefox.profiles.${config.home.username} = {
        isDefault = true;
        name = config.home.username;
      };

      stylix.targets.firefox.profileNames = [config.home.username];

      features.theming = {
        colorscheme = "atlas";
        cursor = "BreezeX-Dark";
      };

      programs.ghostty = {
        clearDefaultKeybinds = true;
        settings.keybind = [
          "super+c=copy_to_clipboard"
          "super+v=paste_from_clipboard"
          "super+w=close_window"
          "super+q=quit"
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"

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

      programs.ashell.settings = lib.mkIf osConfig.programs.hyprland.enable {
        modules = {
          left = [
            "Workspaces"
            "WindowTitle"
          ];
          center = [
            "Tempo"
            "MediaPlayer"
          ];
          right = [
            "Tray"
            "Notifications"
            "SystemInfo"
            "Settings"
          ];
        };

        media_player.indicator_format = "IconAndTitle";
        notifications.grouped = true;

        settings = {
          peripheral_indicators = "All";
          audio_indicator_format = "IconAndPercentage";
          indicators = [
            "Audio"
            "Microphone"
            "Network"
            "Bluetooth"
            "PeripheralBattery"
          ];
          bluetooth_more_cmd = "${config.features.terminal-emulator.bin} ${config.features.terminal-emulator.execFlag} ${lib.getExe pkgs.bluetui}";
        };

        tempo.clock_format = "%R • %e";
        tray.right_click = "Menu";

        workspaces = {
          disable_special_workspaces = true;
          enable_workspace_filling = true;
          max_workspaces = 9;
          workspace_names = [
            "一"
            "二"
            "三"
            "四"
            "五"
            "六"
            "七"
            "八"
            "九"
            "十"
          ];
        };

        osd.enabled = true;
      };

      wayland.windowManager.hyprland.settings.gesture = lib.mkIf osConfig.programs.hyprland.enable [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
          scale = 0.5;
        }
        {
          fingers = 3;
          direction = "vertical";
          action = "special";
          workspace_name = "scratch";
          scale = 0.5;
        }
        {
          fingers = 3;
          direction = "pinch";
          action = "fullscreen";
        }
      ];

      wayland.windowManager.hyprland.settings.config = lib.mkIf osConfig.programs.hyprland.enable {
        general = {
          gaps_in = 4;
          gaps_out = 4;
        };

        decoration = {
          rounding = 8;
        };

        cursor = {
          inactive_timeout = 6;
        };

        input = {
          kb_model = "pc104";
          kb_layout = "dk";
          kb_options = "ctrl:nocaps,lv3:alt_switch";
          repeat_delay = 450;
          repeat_rate = 67;

          touchpad = {
            natural_scroll = true;
          };
        };
      };

      services.hyprpaper.settings.wallpaper = [
        {
          monitor = "";
          path = "${./wallpapers}";
        }
      ];

      programs.git.settings = {
        user = {
          name = "Yevheniia Sakharova";
          email = "sjane1504@gmail.com";
        };
      };

      programs.jujutsu.settings = {
        user = {
          name = "Yevheniia Sakharova";
          email = "sjane1504@gmail.com";
        };
      };

      programs.nixvim = {
        opts = {
          exrc = true;
          undolevels = 10000;

          wrap = false;
          virtualedit = "block";

          number = true;
          relativenumber = true;
          jumpoptions = "view";

          expandtab = true;
          tabstop = 2;
          shiftround = true;
          shiftwidth = 2;

          termguicolors = true;
          cursorline = true;
          smoothscroll = true;

          ignorecase = true;
          smartcase = true;
          smartindent = true;

          conceallevel = 2;
        };

        clipboard.register = "unnamedplus";
        globals.mapleader = " ";

        lsp.servers.copilot.enable = true;

        plugins.which-key.settings.spec = [
          {
            __unkeyed-1 = "<C-s>";
            __unkeyed-2 = "<cmd>w<cr><esc>";
            mode = ["i" "x" "n" "s"];
            desc = "Save file";
            silent = false;
          }
          {
            __unkeyed-1 = "<esc>";
            __unkeyed-2 = "<cmd>noh<cr><esc>";
            mode = ["i" "n" "s"];
            desc = "Escape and clear search highlight";
            silent = false;
          }
        ];
      };

      xdg.enable = true;
      home.stateVersion = "26.05";
    };
  };
}
