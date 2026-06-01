{ self, inputs, ... }:
{
	flake.nixosModules.waybar = { pkgs, lib, ... }: {
		fonts.packages = with pkgs; [ font-awesome_4 ];
		programs.waybar.enable = true;
	};
}
