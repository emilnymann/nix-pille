{ self, inputs, ... }:
{
	flake.nixosModules.bitwarden = { pkgs, lib, ... }: {
		options.programs.bitwarden.enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
		};

		config.environment.systemPackages = with pkgs; [ bitwarden-desktop ];
	};
}
