{ self, inputs, ... }:
{
	flake.nixosModules.discord = { pkgs, lib, ... }: {
		environment.systemPackages = with pkgs; [ discord ];
	};
}
