_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "a";
          group = "Around";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "i";
          group = "Inside";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "ao";
          desc = "Block / conditional / loop";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "io";
          desc = "Block / conditional / loop";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "af";
          desc = "Function";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "if";
          desc = "Function";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "ac";
          desc = "Class";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "ic";
          desc = "Class";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "at";
          desc = "Tag";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "it";
          desc = "Tag";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "ad";
          desc = "Digits";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "id";
          desc = "Digits";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "ae";
          desc = "Word with case";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "ie";
          desc = "Word with case";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "ag";
          desc = "Buffer";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "ig";
          desc = "Buffer";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "au";
          desc = "Function call";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "iu";
          desc = "Function call";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "aU";
          desc = "Function call without dot";
          mode = ["o" "x"];
        }
        {
          __unkeyed-1 = "iU";
          desc = "Function call without dot";
          mode = ["o" "x"];
        }
      ];

      plugins.mini-ai = {
        enable = true;
        settings = {
          n_lines = 500;
          custom_textobjects.__raw = ''
            (function()
              local ai = require("mini.ai")
              return {
                o = ai.gen_spec.treesitter({ -- code block
                  a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                  i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                }),
                f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
                c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
                t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
                d = { "%f[%d]%d+" }, -- digits
                e = { -- Word with case
                  { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
                  "^().*()$",
                },
                g = function() -- buffer
                  local from = { line = 1, col = 1 }
                  local last_line = vim.fn.line("$")
                  local to = {
                    line = last_line,
                    col = math.max(vim.fn.getline(last_line):len(), 1),
                  }
                  return { from = from, to = to }
                end,
                u = ai.gen_spec.function_call(), -- u for "Usage"
                U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
              }
            end)()
          '';
        };
      };
    };
  };
}
