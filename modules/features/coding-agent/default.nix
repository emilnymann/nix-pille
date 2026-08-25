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

    subagentsSettings = {
      showCost = true;
      reportUsage = true;
    };
  in {
    programs.pi-coding-agent = {
      enable = true;
      extraPackages = [
        pkgs.nodejs
        pkgs.ast-grep
      ];

      settings = {
        defaultProvider = "github-copilot";
        defaultModel = "gpt-5.6-luna";
        defaultThinkingLevel = "xhigh";
        enabledModels = [
          "kimi-k3"
          "gpt-5.6*"
        ];

        packages = [
          "npm:pi-mcp-adapter"
          "npm:@tintinweb/pi-subagents"
          "npm:pi-web-access"
          "npm:@h4rvey-g/context-mode"
          "npm:@tintinweb/pi-tasks"
          "npm:@narumitw/pi-btw"
          "npm:pi-powerline-footer"
        ];

        powerline = {
          welcome = true;
          placement = "below";
          preset = "nerd";
          separator = "dot";
          cost = {
            subscriptionDisplay = "reported-cost";
            currency = "USD";
          };

          layout = {
            left = ["session" "model" "thinking" "cost"];
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
      file.".pi/agent/subagents.json".source = jsonFormat.generate "pi-subagents-settings.json" subagentsSettings;
    };
  };
}
