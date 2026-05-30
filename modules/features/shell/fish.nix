{ self, inputs, ... }: { 
	flake.nixosModules.fish = { pkgs, lib, ... }: {
		options.nixosModules.fish.enable = lib.mkEnableOption "fish";
		config = {
			nixosModules.fish.enable = true;
			programs.fish = {
				enable = true;
				interactiveShellInit = ''
					set fish_greeting
				'';
			};

			environment.systemPackages = with pkgs; [
				fishPlugins.pure
			];
		};
	}; 

	flake.homeModules.fish = { pkgs, lib, config, ... }: {
		options.homeModules.fish.enable = lib.mkEnableOption "fish";
		config = {
			homeModules.fish.enable = true;
			xdg.config.files."ghostty/config.ghostty" = lib.mkIf config.homeModules.ghostty.enable {
				text = lib.mkAfter ''
					command = ${pkgs.fish}/bin/fish
				'';
			};
		};
	};
} 
