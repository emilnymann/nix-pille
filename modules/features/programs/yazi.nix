{ self, inputs, ... }:
{
	flake.nixosModules.yazi = { pkgs, lib, ... }: {
		options.nixosModules.yazi.enable = lib.mkEnableOption "yazi";
		config = {
			nixosModules.yazi.enable = true;
			programs.yazi.enable = true;
		};
	};
}
