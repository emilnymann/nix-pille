{ self, inputs, ... }:
{
	flake.nixosModules.hyprland = { pkgs, lib, ... }: {
		options.nixosModules.hyprland.enable = lib.mkEnableOption "hyprland";
		config = {
			nixosModules.hyprland.enable = true;
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
	};
}
