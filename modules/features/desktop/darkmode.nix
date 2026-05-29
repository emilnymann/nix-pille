{ self, inputs, ... }:
{
	flake.nixosModules.darkmode = { pkgs, lib, ... }: {
		options.features.darkmode.enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
		};

		config = {
			features.darkmode.enable = true;

			programs.dconf = {
				enable = true;
				profiles.darkmode.databases = [{
					settings = {
						"org/gnome/desktop/interface" = {
							color-scheme = "prefer-dark";
						};
					};
				}];
			};

			xdg.portal = {
				enable = true;
				extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
			};
		};
	};

	flake.homeModules.darkmode = { self, pkgs, lib, config, ... }: {
		options.features.darkmode.enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
		};

		config = {
			homeModules.gtk-conf = {
				settings3.Settings = {
					gtk-application-prefer-dark-theme = 1;
					gtk-theme-name = "adw-gtk3-dark";
				};
				settings4.Settings = {
					gtk-application-prefer-dark-theme = 1;
				};
			};

			xdg.config.files = {
				"environment.d/dark-mode.conf" = {
					generator = lib.generators.toKeyValue {};
					value = {
						DCONF_PROFILE = "darkmode";
						QT_STYLE_OVERRIDE = "adwaita-dark";
						QT_QPA_PLATFORMTHEME = "gtk3";
						GTK_THEME = "adw-gtk3-dark";
					};
				};
			};
		};
	};
}
