{ self, inputs, ... }:
{
	flake.nixosModules.discord = { pkgs, lib, ... }: {
		options.programs.discord.enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
		};

		config.environment.systemPackages = with pkgs; [ discord ];
	};
}
