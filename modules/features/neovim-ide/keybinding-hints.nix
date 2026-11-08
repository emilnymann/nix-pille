_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed-1 = "<leader>?";
            __unkeyed-2.__raw = ''function() require("which-key").show({ global = false }) end'';
            silent = false;
            desc = "Keys";
            icon = {
              icon = "";
              color = "cyan";
            };
          }
        ];
      };
    };
  };
}
