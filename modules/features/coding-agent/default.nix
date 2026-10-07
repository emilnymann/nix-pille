_: {
  flake.homeModules.coding-agent = {pkgs, ...}: let
    jsonFormat = pkgs.formats.json {};

    powerlineTheme = {
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

    mcpConfig = {
      mcpServers = {
        "context7" = {
          enabled = true;
          url = "https://mcp.context7.com/mcp/oauth";
        };
      };
    };
  in {
    programs.pi-coding-agent = {
      enable = true;
      extraPackages = with pkgs; [
        nodejs
        ast-grep
        rtk
        ffmpeg
      ];

      settings = {
        quietStartup = true;
        tuiMode = "fullscreen";
        openaiVerbosity = "low";

        defaultProvider = "github-copilot";
        defaultModel = "gpt-6-luna";
        defaultThinkingLevel = "xhigh";
        enabledModels = [
          "gpt-6-luna"
          "gpt-5.6-luna"
          "claude-haiku-4.5"
        ];

        packages = [
          "npm:pi-rtk-optimizer"
          "npm:pi-subagents"
          "npm:pi-web-access"
          "npm:pi-background-tasks"
          "npm:pi-powerline-footer"
          "npm:pi-blackhole"
          "npm:@juicesharp/rpiv-ask-user-question"
        ];

        powerline = {
          welcome = true;
          placement = "below";
          preset = "nerd";
          separator = "dot";
          model = {
            showThinkingLevel = true;
          };
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

    home = {
      file.".pi/agent/extensions/powerline-footer/theme.json".source = jsonFormat.generate "pi-powerline-footer-theme.json" powerlineTheme;
      file.".pi/agent/mcp.json".source = jsonFormat.generate "pi-mcp-config.json" mcpConfig;
    };
  };
}
