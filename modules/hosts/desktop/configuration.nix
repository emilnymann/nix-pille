{ self, inputs, ... }:
{
	flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.desktop
			inputs.hjem.nixosModules.default
		];
	};

	flake.nixosModules.desktop = { pkgs, config, ... }: {
		imports = (with self.nixosModules; [
			./hardware-configuration.nix

			hyprland
			hyprlauncher
			cursor-theme
			waybar
			bitwarden
			firefox
			ghostty
			git
			yazi
			gpg
			fish
			nvim
			discord
			darkmode
		]) ++ (with self.userModules; [
			ens
		]);

		networking = {
			hostName = "argon";
			networkmanager.enable = true;
		};

		boot = {
			plymouth.enable = true;
			kernelParams = [ "quiet" ];
			loader = {
				systemd-boot.enable = true;
				efi.canTouchEfiVariables = true;
			};
		};

		time.timeZone = "Europe/Copenhagen";
		console.keyMap = "dk-latin1";
		i18n = {
			defaultLocale = "en_DK.UTF-8";
			extraLocaleSettings = {
				LC_ADDRESS = "da_DK.UTF-8";
				LC_IDENTIFICATION = "da_DK.UTF-8";
				LC_MEASUREMENT = "da_DK.UTF-8";
				LC_MONETARY = "da_DK.UTF-8";
				LC_NAME = "da_DK.UTF-8";
				LC_NUMERIC = "da_DK.UTF-8";
				LC_PAPER = "da_DK.UTF-8";
				LC_TELEPHONE = "da_DK.UTF-8";
				LC_TIME = "da_DK.UTF-8";
			};
		};

		services.greetd = {
			enable = true;
			settings.default_session = {
				user = "ens";
			};
		};

		nix = {
			settings.experimental-features = [ "nix-command" "flakes" ];
			optimise.automatic = true;
			gc = {
				automatic = true;
				randomizedDelaySec = "14m";
				options = "--delete-older-than 10d";
			};
		};

		nixpkgs.config.allowUnfree = true;
		
		system.stateVersion = "26.05";

		hardware.graphics.enable = true;
		hardware.enableRedistributableFirmware = true;

		environment.systemPackages = with pkgs; [
			wget
			vim
			git
		];

		hjem.specialArgs.osConfig = config;

		users = {
			users.ens = {
				isNormalUser = true;
				extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" ];
			};
		};
	};
}
