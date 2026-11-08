_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<C-h>";
        __unkeyed-2 = "<C-w>h";
        desc = "Go to left window";
        silent = false;
      }
      {
        __unkeyed-1 = "<C-j>";
        __unkeyed-2 = "<C-w>j";
        desc = "Go to lower window";
        silent = false;
      }
      {
        __unkeyed-1 = "<C-k>";
        __unkeyed-2 = "<C-w>k";
        desc = "Go to upper window";
        silent = false;
      }
      {
        __unkeyed-1 = "<C-l>";
        __unkeyed-2 = "<C-w>l";
        desc = "Go to right window";
        silent = false;
      }
    ];
  };
}
