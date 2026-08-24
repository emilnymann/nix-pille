_: {
  flake.homeModules.coding-agent = {pkgs, ...}: {
    programs.pi-coding-agent = {
      enable = true;
      extraPackages = [pkgs.nodejs];

      settings = {
        defaultProvider = "github-copilot";
        defaultModel = "gpt-5.6-luna";
        defaultThinkingLevel = "xhigh";
        enabledModels = [
          "kimi-k3"
          "gpt-5.6*"
        ];

        editorPaddingX = 1;

        packages = [
          "npm:pi-mcp-adapter"
          "npm:@tintinweb/pi-subagents"
          "npm:pi-web-access"
          "npm:@h4rvey-g/context-mode"
          "npm:@mjasnikovs/pi-task"
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
  };
}
