{ self, inputs, ... }:
{
	flake.nixosModules.gpg = { pkgs, lib, ... }: {
		programs.gnupg.agent = {
			enable = true;
			enableSSHSupport = true;
		};
	};
}
