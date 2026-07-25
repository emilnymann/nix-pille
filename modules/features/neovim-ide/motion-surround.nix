_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        mini-surround = {
          enable = true;
          settings = {
            mappings = {
              add = "gsa";
              delete = "gsd";
              find = "gsf";
              find_left = "gsF";
              highlight = "gsh";
              replace = "gsr";
              update_n_lines = "gsn";
            };
          };
        };
      };

      extraConfigLua = ''
        require("which-key").add({
          { "gs",  group = "surround" },
          { "gsa", desc = "Add Surrounding",                        mode = { "n", "x" } },
          { "gsd", desc = "Delete Surrounding" },
          { "gsf", desc = "Find Right Surrounding" },
          { "gsF", desc = "Find Left Surrounding" },
          { "gsh", desc = "Highlight Surrounding" },
          { "gsr", desc = "Replace Surrounding" },
          { "gsn", desc = "Update `MiniSurround.config.n_lines`" },
        })
      '';
    };
  };
}
