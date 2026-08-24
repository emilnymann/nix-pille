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
        packages = [
          "npm:pi-mcp-adapter"
          "npm:@tintinweb/pi-subagents"
          "npm:pi-web-access"
          "npm:@h4rvey-g/context-mode"
        ];
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
