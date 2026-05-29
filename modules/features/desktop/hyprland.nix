{ self, inputs, ... }:
{
	flake.nixosModules.hyprland = { pkgs, lib, ... }: {
		programs.hyprland = {
			enable = true;
			withUWSM = true;
		};

		services.greetd.settings.default_session.command = "uwsm start hyprland-uwsm.desktop";

		xdg.portal = {
			enable = true;
			extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
		};
	};
}
