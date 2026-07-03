{
  self,
  ...
}:
{
  flake.homeModules.ens-darwin-laptop = {
    imports = with self.homeModules; [
      ens-base
      file-browser
      web-browser
      password-manager
      terminal-emulator
      theming
      discord
    ];
  };
}
