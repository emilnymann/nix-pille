{ self, inputs, ... }:
{
	flake.homeModules.gtk-conf = { lib, config, ... }: {
		options.homeModules.gtk-conf = {
			settings3 = lib.mkOption {
				type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
				default = {};
			};
			settings4 = lib.mkOption {
				type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
				default = {};
			};
		};

		config = {
			xdg.config.files = {
				"gtk-3.0/settings.ini" = {
					generator = lib.generators.toINI {};
					value = config.homeModules.gtk-conf.settings3;
				};
				"gtk-4.0/settings.ini" = {
					generator = lib.generators.toINI {};
					value = config.homeModules.gtk-conf.settings4;
				};
			};
		};

	};
}
