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
      signing = {
        behavior = "own";
        backend = "gpg";
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

      plugins.sidekick = {
        enable = true;
        settings.cli.tools.pi.cmd = ["pi" "--continue"];
      };

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
        {
          __unkeyed-1 = "<C-a>";
          __unkeyed-2.__raw = ''function() require("sidekick").nes_jump_or_apply() end'';
          desc = "Next Edit Suggestion";
          icon = {
            icon = "";
            color = "green";
          };
        }
        {
          __unkeyed-1 = "<C-.>";
          __unkeyed-2.__raw = ''function() require("sidekick.cli").focus({ name = "pi" }) end'';
          mode = ["n" "t" "i" "x"];
          desc = "Focus Sidekick";
          icon = {
            icon = "";
            color = "blue";
          };
        }
        {
          __unkeyed-1 = "<leader>a";
          group = "AI";
          icon = {
            icon = "";
            color = "purple";
          };
        }
        {
          __unkeyed-1 = "<leader>aa";
          __unkeyed-2.__raw = ''function() require("sidekick.cli").toggle({ name = "pi", focus = true }) end'';
          desc = "Toggle";
          icon = {
            icon = "";
            color = "green";
          };
        }
        {
          __unkeyed-1 = "<leader>ad";
          __unkeyed-2.__raw = ''function() require("sidekick.cli").close() end'';
          desc = "Close";
          icon = {
            icon = "󰅙";
            color = "red";
          };
        }
        {
          __unkeyed-1 = "<leader>av";
          __unkeyed-2.__raw = ''function() require("sidekick.cli").send({ name = "pi", msg = "{selection}" }) end'';
          mode = ["x"];
          desc = "Send Selection";
          icon = {
            icon = "󰒅";
            color = "cyan";
          };
        }
        {
          __unkeyed-1 = "<leader>af";
          __unkeyed-2.__raw = ''function() require("sidekick.cli").send({ name = "pi", msg = "{file}" }) end'';
          mode = ["x" "n"];
          desc = "Send File";
          icon = {
            icon = "";
            color = "yellow";
          };
        }
      ];
    };

    programs.pi-coding-agent = {
      settings = {
        quietStartup = true;
        tuiMode = "fullscreen";
        openaiVerbosity = "low";

        defaultProvider = "github-copilot";
        defaultModel = "gpt-6-luna";
        defaultThinkingLevel = "xhigh";
        enabledModels = [
          "gpt-6-luna"
          "claude-haiku-4.5"
          "gemini-4-argon"
        ];

        packages = [
          "npm:pi-rtk-optimizer"
          "npm:pi-subagents"
          "npm:pi-web-access"
          "npm:pi-background-tasks"
          "npm:pi-powerline-footer"
          "npm:pi-blackhole"
          "npm:@juicesharp/rpiv-ask-user-question"
          "npm:@juicesharp/rpiv-todo"
        ];

        powerline = {
          welcome = true;
          placement = "below";
          preset = "nerd";
          separator = "dot";
          model.showThinkingLevel = true;
          cost = {
            subscriptionDisplay = "reported-cost";
            currency = "USD";
          };
          layout = {
            left = ["session" "model" "cost"];
            right = ["token_in" "token_out" "cache_read" "context_pct" "time_spent" "subagents"];
            secondary = ["extension_statuses"];
          };
        };
      };

      keybindings = {
        "tui.editor.historyNext" = ["ctrl+n" "down"];
        "tui.editor.historyPrevious" = ["ctrl+p" "up"];
        "tui.editor.newLine" = ["enter"];
        "tui.editor.submit" = ["ctrl+enter"];
      };
    };

    home.file = let
      jsonFormat = pkgs.formats.json {};
    in {
      ".pi/agent/extensions/powerline-footer/theme.json".source = jsonFormat.generate "pi-powerline-footer-theme.json" {
        colors = {
          model = "muted";
          shellMode = "borderMuted";
          path = "muted";
          gitDirty = "warning";
          gitClean = "dim";
          thinking = "dim";
          thinkingMinimal = "dim";
          thinkingLow = "muted";
          thinkingMedium = "muted";
          context = "dim";
          contextWarn = "warning";
          contextError = "error";
          cost = "text";
          tokens = "dim";
          queue = "muted";
          separator = "borderMuted";
          border = "borderMuted";
        };
        icons.warning = "";
      };
      ".pi/agent/mcp.json".source = jsonFormat.generate "pi-mcp-config.json" {
        mcpServers.context7 = {
          enabled = true;
          url = "https://mcp.context7.com/mcp/oauth";
        };
      };
    };

    xdg.enable = true;
    home.stateVersion = "26.05";
  };
}
