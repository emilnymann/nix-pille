vim.lsp.config("nixd", {
	settings = {
		nixd = {
			nixpkgs = {
				expr = [[import (builtins.getFlake "/etc/nixos").inputs.nixpkgs { }]],
			},
			options = {
				nixos = {
					expr = [[(builtins.getFlake "/etc/nixos").nixosConfigurations.argon.options]],
				},
				["home-manager"] = {
					expr = [[(builtins.getFlake "/etc/nixos").nixosConfigurations.argon.options.home-manager.users.type.getSubOptions []]],
				},
        ["flake-parts"] = {
          expr = [[(builtins.getFlake "/etc/nixos").debug.options]],
        },
			},
		},
	},
})
