{ flake.nixosModules.hyprland = { pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    hyprlauncher
  ];

  programs.regreet.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "uwsm start hyprland-uwsm.desktop";
	user = "ens";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hjem.users.ens.xdg.config.files = {
    "hypr/hyprland.lua".source = ./config/hyprland.lua;
    "hypr/hyprland".source = ./config/hyprland;
  };
}; }
