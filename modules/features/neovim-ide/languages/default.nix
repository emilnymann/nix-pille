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


      extraConfigLua = ''
        _G.format_gdscript = function(bufnr)
          local filename = vim.api.nvim_buf_get_name(bufnr)
          if filename == "" then
            return
          end

          local dir = vim.fs.dirname(filename)
          local tempname = vim.fn.fnamemodify(vim.fn.tempname(), ":t")
          local temp_file = vim.fs.joinpath(dir, "." .. tempname .. ".gd")
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

          if vim.fn.writefile(lines, temp_file) ~= 0 then
            vim.notify("Could not create a temporary file for gdformat", vim.log.levels.ERROR)
            return
          end

          local result = vim.system({"gdformat", temp_file}, {
            cwd = dir,
            text = true,
          }):wait()
          if result.code ~= 0 then
            vim.fn.delete(temp_file)
            local details = result.stderr ~= "" and result.stderr or result.stdout
            vim.notify("gdformat failed: " .. details, vim.log.levels.ERROR)
            return
          end

          local formatted = vim.fn.readfile(temp_file)
          vim.fn.delete(temp_file)
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
        end
      '';

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

              if vim.bo[args.buf].filetype == "gdscript" then
                _G.format_gdscript(args.buf)
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
              if vim.bo[bufnr].filetype == "gdscript" then
                _G.format_gdscript(bufnr)
                return
              end

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
