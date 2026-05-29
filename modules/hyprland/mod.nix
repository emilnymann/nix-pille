{ flake.nixosModules.hyprland = { pkgs, ... }: {
  environment.systemPackages = [
    pkgs.wl-clipboard
    pkgs.hyprlauncher
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
}; }
