{ self, inputs, ... }:
{
	flake.nixosModules.darkmode = { pkgs, lib, ... }: {
		options.nixosModules.darkmode.enable = lib.mkEnableOption "darkmode";
		config = {
			nixosModules.darkmode.enable = true;

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

	flake.homeModules.darkmode = { pkgs, lib, config, ... }: {
		options.homeModules.darkmode.enable = lib.mkEnableOption "darkmode";
		config = {
			homeModules.darkmode.enable = true;
			xdg.config.files = {
				"gtk-3.0/settings.ini" = {
					generator = lib.mkDefault (lib.generators.toINI {});
					value = {
						Settings = {
							gtk-application-prefer-dark-theme = 1;
							gtk-theme-name = "adw-gtk3-dark";
						};
					};
				};

				"gtk-4.0/settings.ini" = {
					generator = lib.mkDefault (lib.generators.toINI {});
					value = {
						Settings = {
							gtk-application-prefer-dark-theme = 1;
						};
					};
				};

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
