{ self, inputs, ... }:
{
	flake.nixosModules.waybar = { pkgs, lib, ... }: {
		options.nixosModules.yazi.enable = lib.mkEnableOption "waybar";
		config = {
			nixosModules.yazi.enable = true;
			fonts.packages = with pkgs; [ font-awesome_4 ];
			programs.waybar.enable = true;
		};
	};
}
