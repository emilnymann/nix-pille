{ self, inputs, ... }:
{
	flake.nixosModules.hyprlauncher = { pkgs, lib, ... }: {
		options.programs.hyprlauncher.enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
		};

		config.environment.systemPackages = with pkgs; [ hyprlauncher ];
	};
}
