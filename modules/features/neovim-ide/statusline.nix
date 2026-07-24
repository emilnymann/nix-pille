_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins = {
        lualine = {
          enable = true;
          settings = {
            options = {
              theme = "auto";
              globalstatus = true;
            };
            sections = {
              lualine_a = ["mode"];
              lualine_c = [
                {
                  __unkeyed-1 = "filetype";
                  icon_only = true;
                  separator = "";
                  padding = {
                    left = 1;
                    right = 0;
                  };
                }
              ];

              lualine_x = [
                {
                  __unkeyed-1.__raw = ''function() return require("noice").api.status.command.get() end'';
                  cond.__raw = ''function() return package.loaded["noice"] and require("noice").api.status.command.has() end'';
                  color.__raw = ''function() return { fg = Snacks.util.color("Statement") } end'';
                }
              ];

              lualine_z.__raw = "{}";

              lualine_y = [
                {
                  __unkeyed-1 = "progress";
                  separator = " ";
                  padding = {
                    left = 1;
                    right = 0;
                  };
                }
                {
                  __unkeyed-1 = "location";
                  padding = {
                    left = 0;
                    right = 1;
                  };
                }
              ];
            };
          };
        };
      };
    };
  };
}
