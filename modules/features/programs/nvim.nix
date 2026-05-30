{ self, inputs, ... }:
{
	flake.nixosModules.nvim = { pkgs, ... }: {
		programs.neovim = {
			enable = true;
			defaultEditor = true;
		};
	};
}
