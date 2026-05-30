{ self, inputs, ... }:
{
	flake.nixosModules.git = { pkgs, lib, ... }: {
		options.nixosModules.git.enable = lib.mkEnableOption "git";
		config = {
			nixosModules.git.enable = true;
			programs.git.enable = true;
			environment.systemPackages = with pkgs; [ lazygit ];
		};
	};
}
