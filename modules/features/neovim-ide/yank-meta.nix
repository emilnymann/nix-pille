_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>y";
          group = "Yank";
        }
      ];

      keymaps = [
        {
          mode = ["n"];
          key = "<leader>yf";
          action.__raw = ''
            function()
              local path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
              vim.fn.setreg("+", path)
              vim.notify("Yanked " .. path)
            end
          '';
          options = {
            desc = "Yank filepath relative to CWD";
          };
        }
      ];
    };
  };
}
