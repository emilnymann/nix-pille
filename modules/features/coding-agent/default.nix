_: {
  flake.homeModules.coding-agent = {
    pkgs,
    config,
    lib,
    ...
  }: let
    jsonFormat = pkgs.formats.json {};
  in {
    options.features.coding-agent.mcpServers = lib.mkOption {
      type = lib.types.attrsOf jsonFormat.type;
      default = {};
      description = "MCP servers configured for Pi coding agent.";
    };

    config = {
      programs.pi-coding-agent = {
        enable = true;
        extraPackages = with pkgs; [
          nodejs
          ast-grep
          rtk
          ffmpeg
        ];
      };

      home.file.".pi/agent/mcp.json" = lib.mkIf (config.features.coding-agent.mcpServers != {}) {
        source = jsonFormat.generate "pi-mcp-config.json" {
          mcpServers = config.features.coding-agent.mcpServers;
        };
      };
    };
  };
}
