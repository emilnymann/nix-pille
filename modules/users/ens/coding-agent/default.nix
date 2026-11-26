_: {
  flake.homeModules.ens = {pkgs, ...}: {
    programs.pi-coding-agent = {
      settings = {
        quietStartup = true;
        tuiMode = "fullscreen";
        openaiVerbosity = "low";

        defaultProvider = "github-copilot";
        defaultModel = "gemini-4-neon";
        defaultThinkingLevel = "xhigh";
        modelThinkingLevels = {
          "github-copilot/gemini-4-neon" = "xhigh";
        };
        enabledModels = [
          "gemini-4-neon"
          "gemini-4-hydrogen"
        ];

        subagents = {
          defaultProvider = "github-copilot";
          defaultModel = "gemini-4-hydrogen";
        };

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
        mcpServers = {
          context7 = {
            url = "https://mcp.context7.com/mcp/oauth";
          };
          linear = {
            url = "https://mcp.linear.app/mcp";
          };
        };
      };
      ".pi/agent/AGENTS.md".source = ./agent-instructions.md;
      ".pi/agent/skills/orchestrator/SKILL.md".source = ./skills/orchestrator/SKILL.md;
    };
  };
}
