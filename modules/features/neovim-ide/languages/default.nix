_: {
  flake.homeModules.neovim-ide = {config, lib, ...}: {
    programs.nixvim = {
      plugins = {
        lspconfig.enable = true;
        which-key = {
          enable = true;
          settings.spec = [
            {
              __unkeyed-1 = "<leader>c";
              group = "Code";
            }
          ];
        };
      };


      autoCmd = [
        {
          event = ["BufWritePre"];
          callback.__raw = ''
            function(args)
              local bufname = vim.api.nvim_buf_get_name(args.buf)
              if bufname == "" then
                return
              end

              local dir = vim.fs.dirname(bufname)
              local marker = vim.fs.find(".format-on-save", {
                path = dir,
                upward = true,
              })[1]

              if not marker then
                return
              end

              local use_biome = #vim.lsp.get_clients({
                bufnr = args.buf,
                name = "biome",
              }) > 0

              vim.lsp.buf.format({
                bufnr = args.buf,
                async = false,
                filter = use_biome and function(client)
                  return client.name == "biome"
                end or nil,
              })
            end
          '';
        }
      ];

      keymaps = [
        {
          mode = ["n"];
          key = "gd";
          action.__raw = "function() Snacks.picker.lsp_definitions() end";
          options = {desc = "Goto definition";};
        }
        {
          mode = ["n"];
          key = "gr";
          action.__raw = "function() Snacks.picker.lsp_references() end";
          options = {
            desc = "Goto references";
            nowait = true;
          };
        }
        {
          mode = ["n"];
          key = "gI";
          action.__raw = "function() Snacks.picker.lsp_implementations() end";
          options = {desc = "Goto Implementation";};
        }
        {
          mode = ["n"];
          key = "gy";
          action.__raw = "function() Snacks.picker.lsp_type_definitions() end";
          options = {desc = "Goto t[y]pe definition";};
        }
        {
          mode = ["n"];
          key = "gD";
          action.__raw = "function() Snacks.picker.lsp_declarations() end";
          options = {desc = "Goto Declaration";};
        }
        {
          mode = ["n"];
          key = "K";
          action.__raw = "function() vim.lsp.buf.hover() end";
          options = {desc = "Hover";};
        }
        {
          mode = ["n" "v"];
          key = "<leader>ca";
          action.__raw = "function() vim.lsp.buf.code_action() end";
          options = {desc = "Code action";};
        }
        {
          mode = ["n"];
          key = "<leader>cr";
          action.__raw = "function() vim.lsp.buf.rename() end";
          options = {desc = "Rename symbol";};
        }
        {
          mode = ["n"];
          key = "gK";
          action.__raw = "function() vim.lsp.buf.signature_help() end";
          options = {desc = "Signature help";};
        }
        {
          mode = ["i"];
          key = "<c-k>";
          action.__raw = "function() vim.lsp.buf.signature_help() end";
          options = {desc = "Signature help";};
        }
        {
          mode = ["n" "v"];
          key = "<c-f>";
          action.__raw = ''
            function()
              local bufnr = vim.api.nvim_get_current_buf()
              local use_biome = #vim.lsp.get_clients({
                bufnr = bufnr,
                name = "biome",
              }) > 0

              vim.lsp.buf.format({
                bufnr = bufnr,
                async = false,
                filter = use_biome and function(client)
                  return client.name == "biome"
                end or nil,
              })
            end
          '';
          options = {desc = "Format buffer / selection";};
        }
      ];
    };
  };
}
