_: {
  flake.homeModules.neovim-ide = {pkgs, ...}: let
    browsers = pkgs.playwright-driver.browsers;
    chromeHeadlessShell = pkgs.writeShellScriptBin "snacks-chrome-headless-shell" ''
      browser="$(${pkgs.findutils}/bin/find -L ${browsers} \
        -type f -name chrome-headless-shell -perm -111 -print -quit)"

      if [ -z "$browser" ]; then
        echo "chrome-headless-shell not found" >&2
        exit 1
      fi

      exec "$browser" "$@"
    '';
  in {
    programs.nixvim = {
      extraPackages = [
        pkgs.ghostscript
        pkgs.tectonic
        pkgs.mermaid-cli
        browsers
        chromeHeadlessShell
      ];

      extraConfigLuaPre = ''
        vim.env.PUPPETEER_EXECUTABLE_PATH = "${chromeHeadlessShell}/bin/snacks-chrome-headless-shell"
      '';

      dependencies.imagemagick.enable = true;

      plugins = {
        snacks = {
          enable = true;
          settings = {
            image = {
              enabled = true;
            };
          };
        };
      };
    };
  };
}
