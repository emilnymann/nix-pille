{ self, inputs, lib, ... }:
{
	flake.userModules.ens = { pkgs, lib, config, ... }: {
		hjem.users.ens = {
			imports = with self.homeModules; [
				gtk-conf
				ghostty
				fish
				darkmode
				cursor-theme.rose-pine
        lazyvim
			];

			xdg.config.files = {
				"hypr/hyprland.lua".source = ./config/hypr/hyprland.lua;
				"hypr/hyprland".source = ./config/hypr/hyprland;

				"git/config".text = ''
					[user]
						name = Emil Nymann Sølyst
						email = emilnymann96@gmail.com
						signingkey = 45E51048D62204CCD70B633B31D710749D7D8E7B
					[commit]
						gpgsign = true
					[tag]
						gpgsign = true
				'';
			};
		};
	};
}
