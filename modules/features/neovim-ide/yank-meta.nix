_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>y";
          group = "Yank";
          icon = {
            icon = "";
            color = "green";
          };
        }
        {
          __unkeyed-1 = "<leader>yf";
          __unkeyed-2.__raw = ''
            function()
              local path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
              vim.fn.setreg("+", path)
              vim.notify("Yanked " .. path)
            end
          '';
          silent = false;
          desc = "Filepath (CWD)";
          icon = {
            icon = "󰉋";
            color = "blue";
          };
        }
      ];
    };
  };
}
