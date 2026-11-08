_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      lsp.servers.copilot.enable = true;
      plugins = {
        sidekick = {
          enable = true;
          settings = {
            cli = {
              tools = {
                pi = {
                  cmd = ["pi" "--continue"];
                };
              };
            };
          };
        };

        lualine = {
          settings = {
            sections = {
              lualine_z = [
                {
                  __unkeyed-1.__raw = ''function() return require("noice").api.status.command.get() end'';
                  cond.__raw = ''function() return package.loaded["noice"] and require("noice").api.status.command.has() end'';
                  color.__raw = ''function() return { fg = Snacks.util.color("Statement") } end'';
                }
              ];
            };
          };
        };

        which-key.settings.spec = [
          {
            __unkeyed-1 = "<C-a>";
            __unkeyed-2.__raw = ''function() require("sidekick").nes_jump_or_apply() end'';
            desc = "Next Edit Suggestion";
            icon = {
              icon = "";
              color = "green";
            };
          }
          {
            __unkeyed-1 = "<C-.>";
            __unkeyed-2.__raw = ''function() require("sidekick.cli").focus({ name = "pi" }) end'';
            mode = ["n" "t" "i" "x"];
            desc = "Focus Sidekick";
            icon = {
              icon = "";
              color = "blue";
            };
          }
          {
            __unkeyed-1 = "<leader>a";
            group = "AI";
            icon = {
              icon = "";
              color = "purple";
            };
          }
          {
            __unkeyed-1 = "<leader>aa";
            __unkeyed-2.__raw = ''function() require("sidekick.cli").toggle({ name = "pi", focus = true }) end'';
            desc = "Toggle";
            icon = {
              icon = "";
              color = "green";
            };
          }
          {
            __unkeyed-1 = "<leader>ad";
            __unkeyed-2.__raw = ''function() require("sidekick.cli").close() end'';
            desc = "Close";
            icon = {
              icon = "󰅙";
              color = "red";
            };
          }
          {
            __unkeyed-1 = "<leader>av";
            __unkeyed-2.__raw = ''function() require("sidekick.cli").send({ name = "pi", msg = "{selection}" }) end'';
            mode = ["x"];
            desc = "Send Selection";
            icon = {
              icon = "󰒅";
              color = "cyan";
            };
          }
          {
            __unkeyed-1 = "<leader>af";
            __unkeyed-2.__raw = ''function() require("sidekick.cli").send({ name = "pi", msg = "{file}" }) end'';
            desc = "Send File";
            icon = {
              icon = "";
              color = "yellow";
            };
          }
        ];
      };
    };
  };
}
