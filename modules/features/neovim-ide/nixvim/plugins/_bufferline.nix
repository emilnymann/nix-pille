_: {
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        icons = {
          enable = true;
        };
      };
    };

    plugins.bufferline = {
      enable = true;
      settings = {
        options = {
          close_command.__raw = "function(n) Snacks.bufdelete(n) end";
          diagnostics = "nvim_lsp";
          always_show_bufferline = false;
          diagnostics_indicator.__raw = ''
            function(_, _, diag)
              return vim.trim((diag.error and " " .. diag.error .. " " or "")
                .. (diag.warning and " " .. diag.warning or "")
              )
            end
          '';
          offsets = [
            {
              filetype = "neo-tree";
              text = "Neo-tree";
              highlight = "Directory";
              text_align = "left";
            }
            {
              filetype = "snacks_layout_box";
            }
          ];
        };
      };
    };
  };
}
