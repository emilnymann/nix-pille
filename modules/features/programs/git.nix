{ self, inputs, ... }:
{
	flake.nixosModules.git = { pkgs, lib, ... }: {
		programs.git.enable = true;
		environment.systemPackages = with pkgs; [ lazygit ];
	};
}
