_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.keymaps = [
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
    ];
  };
}
