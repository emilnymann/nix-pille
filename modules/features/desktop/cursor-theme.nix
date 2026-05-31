{ self, inputs, ... }:
{
	flake.nixosModules.cursor-theme = { pkgs, lib, config, ... }: {
		environment.systemPackages = with pkgs; lib.optionals config.nixosModules.hyprland.enable [
			hyprcursor
		];
	};

	flake.homeModules.cursor-theme.rose-pine = { lib, pkgs, osConfig, ... }: {
		packages = with pkgs; [
			rose-pine-cursor
		] ++ lib.optionals osConfig.nixosModules.hyprland.enable [
			rose-pine-hyprcursor
		];

		xdg.config.files = {
			"environment.d/cursor-theme.conf" = {
				generator = lib.generators.toKeyValue {};
				value = {
					XCURSOR_THEME = "BreezeX-RosePine-Linux";
					XCURSOR_SIZE = 24;
				} // lib.optionalAttrs osConfig.nixosModules.hyprland.enable {
					HYPRCURSOR_THEME = "rose-pine-hyprcursor";
					HYPRCURSOR_SIZE = 24;
				};
			};

			"gtk-3.0/settings.ini" = {
				generator = lib.mkDefault (lib.generators.toINI {});
				value = {
					Settings = {
						gtk-cursor-theme-name = "BreezeX-RosePine-Linux";
						gtk-cursor-theme-size = 24;
					};
				};
			};

			"gtk-4.0/settings.ini" = {
				generator = lib.mkDefault (lib.generators.toINI {});
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
