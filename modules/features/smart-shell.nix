_: {
  flake.homeModules.smart-shell = { pkgs, ... }: {
    home.packages = with pkgs; [
    	fishPlugins.pure
    ];

    programs.fish = {
      enable = true;
      interactiveShellInit = "set fish_greeting";
      plugins = [
      	{ name = "pure"; src = pkgs.fishPlugins.pure.src; }
      ];
    };

    programs.ghostty = {
    	enableFishIntegration = true;
	settings = {
		command = "${pkgs.fish}/bin/fish";
	};
    };
  };
}
