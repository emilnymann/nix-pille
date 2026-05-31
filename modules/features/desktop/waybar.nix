{ self, inputs, ... }:
{
	flake.nixosModules.waybar = { pkgs, lib, ... }: {
		options.nixosModules.waybar.enable = lib.mkEnableOption "waybar";
		config = {
			nixosModules.waybar.enable = true;
			fonts.packages = with pkgs; [ font-awesome_4 ];
			programs.waybar.enable = true;
		};
	};
}
