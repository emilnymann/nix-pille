{ self, inputs, ... }:
{
	flake.nixosModules.cursor-theme = { pkgs, lib, config, ... }: {
		environment.systemPackages = with pkgs; lib.optionals config.programs.hyprland.enable [
			hyprcursor
		];
	};

	flake.homeModules.cursor-theme.rose-pine = { self, lib, pkgs, osConfig, ... }: {
		packages = with pkgs; [
			rose-pine-cursor
		] ++ lib.optionals osConfig.programs.hyprland.enable [
			rose-pine-hyprcursor
		];

		imports = [ self.homeModules.gtk-conf ];

		xdg.config.files = {
			"environment.d/cursor-theme.conf" = {
				generator = lib.generators.toKeyValue {};
				value = {
					XCURSOR_THEME = "BreezeX-RosePine-Linux";
					XCURSOR_SIZE = 24;
				} // lib.optionalAttrs osConfig.programs.hyprland.enable {
					HYPRCURSOR_THEME = "rose-pine-hyprcursor";
					HYPRCURSOR_SIZE = 24;
				};
			};

			"gtk-3.0/settings.ini" = {
				value = {
					Settings = {
						gtk-cursor-theme-name = "BreezeX-RosePine-Linux";
						gtk-cursor-theme-size = 24;
					};
				};
			};

			"gtk-4.0/settings.ini" = {
				value = {
					Settings = {
						gtk-cursor-theme-name = "BreezeX-RosePine-Linux";
						gtk-cursor-theme-size = 24;
					};
				};
			};
		};
	};
}
