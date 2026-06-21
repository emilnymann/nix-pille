_: {
  flake.homeModules.desktop = _: {
    wayland.windowManager.hyprland.settings.gesture = [
      {
        fingers = 3;
        direction = "horizontal";
        action = "workspace";
        scale = 0.5;
      }
      {
        fingers = 3;
        direction = "vertical";
        action = "special";
        workspace_name = "scratch";
        scale = 0.5;
      }
      {
        fingers = 3;
        direction = "pinch";
        action = "fullscreen";
      }
    ];
  };
}
