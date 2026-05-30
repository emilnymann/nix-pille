{ self, inputs, ... }:
{
	flake.nixosModules.firefox = { pkgs, lib, config, ... }: {
		options.nixosModules.firefox.enable = lib.mkEnableOption "firefox";
		config = {
			nixosModules.firefox.enable = true;
			programs.firefox = {
				enable = true;
				policies = {
					ExtensionSettings = {
						# Bitwarden
						"{446900e4-71c2-419f-a6a7-df9c091e268b}" = lib.mkIf config.nixosModules.bitwarden.enable {
							install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
							installation_mode = "force_installed";
						};
					};
				};
			};
		};
	};
}
