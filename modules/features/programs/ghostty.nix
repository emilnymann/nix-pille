{ self, inputs, ... }:
{
	flake.nixosModules.ghostty = { pkgs, lib, ... }: {
		options.nixosModules.ghostty.enable = lib.mkEnableOption "ghostty";
		config = {
			nixosModules.ghostty.enable = true;
			environment.systemPackages = with pkgs; [ ghostty ];
		};
	};

	flake.homeModules.ghostty = { pkgs, lib, ... }: {
		options.homeModules.ghostty.enable = lib.mkEnableOption "ghostty";
		config = {
			homeModules.ghostty.enable = true;
			xdg.config.files."ghostty/config.ghostty".text = ''
				theme = Gruvbox Dark
				window-padding-x = 16
				window-padding-y = 16
			'';
		};
	};
}
