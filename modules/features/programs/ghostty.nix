{ self, inputs, ... }:
{
	flake.nixosModules.ghostty = { pkgs, lib, ... }: {
		options.programs.ghostty.enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
		};

		config.environment.systemPackages = with pkgs; [ ghostty ];
	};

	flake.homeModules.ghostty = { pkgs, lib, config, ... }: {
		options.programs.ghostty.enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
		};

		options.programs.ghostty.shell = lib.mkOption {
			type = lib.types.str;
			default = "${pkgs.bash}/bin/bash";
		};

		config.xdg.config.files."ghostty/config.ghostty" = {
			generator = lib.generators.toKeyValue {};
			value = {
				theme = "Gruvbox Dark";
				window-padding-x = 16;
				window-padding-y = 16;
				command = config.programs.ghostty.shell;
			};
		};
	};
}
