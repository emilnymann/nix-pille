{ self, inputs, ... }:
{
	flake.nixosModules.hyprlauncher = { pkgs, ... }: {
		environment.systemPackages = with pkgs; [ hyprlauncher ];
	};
}
