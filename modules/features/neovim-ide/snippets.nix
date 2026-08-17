_: let
  phpSnippets = {
    "if" = {
      prefix = "if";
      body = [
        "if ($1) {"
        "  $0"
        "}"
      ];
      description = "If block";
    };
    ifelse = {
      prefix = "ife";
      body = [
        "if ($1) {"
        "  $2"
        "} else {"
        "  $0"
        "}"
      ];
      description = "If/else block";
    };
    try = {
      prefix = "try";
      body = [
        "try {"
        "  $1"
        "} catch (\\Throwable $e) {"
        "  $0"
        "}"
      ];
      description = "Try/catch block";
    };
    pubf = {
      prefix = "pubf";
      body = [
        "public function $1($2): $3"
        "{"
        "  $0"
        "}"
      ];
      description = "Public function";
    };
    prif = {
      prefix = "prif";
      body = [
        "private function $1($2): $3"
        "{"
        "  $0"
        "}"
      ];
      description = "Private function";
    };
    match = {
      prefix = "match";
      body = [
        "match ($1) {"
        "  $2 => $3,$0"
        "}"
      ];
      description = "Match statement";
    };
  };
in {
  flake.homeModules.neovim-ide = _: {
    # blink.cmp's native snippets source scans this directory for VS Code
    # snippet JSON files. The snippets are expanded with vim.snippet.expand.
    programs.nixvim.extraFiles."snippets/php.json".text = builtins.toJSON phpSnippets;
  };
}
