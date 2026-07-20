_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      globals.maplocalleader = ",";

      plugins = {
        neorg = {
          enable = true;
          settings = {
            load = {
              "core.defaults".__empty = null;
              "core.concealer".__empty = null;
              "core.keybinds".config.default_keybinds = false;
              "core.dirman".config = {
                workspaces = {
                  notes = "~/notes";
                };
                index = "index.norg";
              };
            };
          };
        };

        which-key.settings.spec = [
          {
            __unkeyed-1 = "<leader>o";
            group = "Org";
          }
          {
            __unkeyed-1 = "<localleader>";
            group = "Org buffer";
          }
          {
            __unkeyed-1 = "<localleader>n";
            group = "Notes";
          }
          {
            __unkeyed-1 = "<localleader>t";
            group = "Tasks";
          }
          {
            __unkeyed-1 = "<localleader>l";
            group = "Lists";
          }
          {
            __unkeyed-1 = "<localleader>i";
            group = "Insert";
          }
        ];
      };

      autoCmd = [
        {
          event = "FileType";
          pattern = "norg";
          callback.__raw = ''
            function(args)
              local maps = {
                { key = "<localleader>nn", action = "<Plug>(neorg.dirman.new-note)", desc = "New note" },
                { key = "<localleader>tu", action = "<Plug>(neorg.qol.todo-items.todo.task-undone)", desc = "Task undone" },
                { key = "<localleader>tp", action = "<Plug>(neorg.qol.todo-items.todo.task-pending)", desc = "Task pending" },
                { key = "<localleader>td", action = "<Plug>(neorg.qol.todo-items.todo.task-done)", desc = "Task done" },
                { key = "<localleader>th", action = "<Plug>(neorg.qol.todo-items.todo.task-on-hold)", desc = "Task on hold" },
                { key = "<localleader>tc", action = "<Plug>(neorg.qol.todo-items.todo.task-cancelled)", desc = "Task cancelled" },
                { key = "<localleader>tr", action = "<Plug>(neorg.qol.todo-items.todo.task-recurring)", desc = "Task recurring" },
                { key = "<localleader>ti", action = "<Plug>(neorg.qol.todo-items.todo.task-important)", desc = "Task important" },
                { key = "<localleader>ta", action = "<Plug>(neorg.qol.todo-items.todo.task-ambiguous)", desc = "Task needs input" },
                { key = "<localleader>lt", action = "<Plug>(neorg.pivot.list.toggle)", desc = "Toggle list type" },
                { key = "<localleader>li", action = "<Plug>(neorg.pivot.list.invert)", desc = "Invert list type" },
                { key = "<localleader>id", action = "<Plug>(neorg.tempus.insert-date)", desc = "Insert date" },
              }

              for _, map in ipairs(maps) do
                vim.keymap.set("n", map.key, map.action, {
                  buffer = args.buf,
                  desc = map.desc,
                  silent = true,
                })
              end

              vim.keymap.set("i", "<C-CR>", "<Plug>(neorg.itero.next-iteration)", {
                buffer = args.buf,
                desc = "Continue item",
                silent = true,
              })
            end
          '';
        }
      ];

      keymaps = [
        {
          mode = ["n"];
          key = "<leader>oo";
          action = "<cmd>Neorg index<cr>";
          options.desc = "Open Org index";
        }
        {
          mode = ["n"];
          key = "<leader>ow";
          action = "<cmd>Neorg workspace notes<cr>";
          options.desc = "Switch to notes workspace";
        }
      ];
    };
  };
}
