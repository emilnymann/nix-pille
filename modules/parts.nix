{ inputs, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  debug = true;

  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
}
