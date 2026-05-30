{ self, inputs, ... }:
{
	flake.nixosModules.bitwarden = { pkgs, lib, ... }: {
		options.nixosModules.bitwarden.enable = lib.mkEnableOption "bitwarden";
		config = {
			nixosModules.bitwarden.enable = true;
			environment.systemPackages = with pkgs; [ bitwarden-desktop ];
		};
	};
}
