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
            __unkeyed-1 = "<leader>oo";
            __unkeyed-2 = "<cmd>Neorg index<cr>";
            desc = "Open Org index";
            silent = false;
          }
          {
            __unkeyed-1 = "<leader>ow";
            __unkeyed-2 = "<cmd>Neorg workspace notes<cr>";
            desc = "Switch to notes workspace";
            silent = false;
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
              if vim.b[args.buf].which_key_neorg_mappings then
                return
              end

              require("which-key").add({
                buffer = args.buf,
                mode = "n",
                silent = true,
                { "<localleader>nn", "<Plug>(neorg.dirman.new-note)", desc = "New note" },
                { "<localleader>tu", "<Plug>(neorg.qol.todo-items.todo.task-undone)", desc = "Task undone" },
                { "<localleader>tp", "<Plug>(neorg.qol.todo-items.todo.task-pending)", desc = "Task pending" },
                { "<localleader>td", "<Plug>(neorg.qol.todo-items.todo.task-done)", desc = "Task done" },
                { "<localleader>th", "<Plug>(neorg.qol.todo-items.todo.task-on-hold)", desc = "Task on hold" },
                { "<localleader>tc", "<Plug>(neorg.qol.todo-items.todo.task-cancelled)", desc = "Task cancelled" },
                { "<localleader>tr", "<Plug>(neorg.qol.todo-items.todo.task-recurring)", desc = "Task recurring" },
                { "<localleader>ti", "<Plug>(neorg.qol.todo-items.todo.task-important)", desc = "Task important" },
                { "<localleader>ta", "<Plug>(neorg.qol.todo-items.todo.task-ambiguous)", desc = "Task needs input" },
                { "<localleader>lt", "<Plug>(neorg.pivot.list.toggle)", desc = "Toggle list type" },
                { "<localleader>li", "<Plug>(neorg.pivot.list.invert)", desc = "Invert list type" },
                { "<localleader>id", "<Plug>(neorg.tempus.insert-date)", desc = "Insert date" },
                { "<C-CR>", "<Plug>(neorg.itero.next-iteration)", mode = "i", desc = "Continue item" },
              })
              vim.b[args.buf].which_key_neorg_mappings = true
            end
          '';
        }
      ];
    };
  };
}
