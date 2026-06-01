{ self, inputs, ... }: { 
	flake.nixosModules.fish = { pkgs, lib, ... }: {
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

	flake.homeModules.fish = { pkgs, lib, config, ... }: {
		options.shell.fish.enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
		};

		config.programs.ghostty.shell = "${pkgs.fish}/bin/fish";
	};
} 
