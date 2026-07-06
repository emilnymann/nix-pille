_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.keymaps = [
      {
        mode = ["n"];
        key = "gd";
        action = "vim.lsp.buf.definition";
        options = {desc = "Goto definition";};
      }
      {
        mode = ["n"];
        key = "gr";
        action = "vim.lsp.buf.references";
        options = {desc = "Goto references";};
      }
      {
        mode = ["n"];
        key = "gI";
        action = "vim.lsp.buf.implementation";
        options = {desc = "Goto Implementation";};
      }
      {
        mode = ["n"];
        key = "gy";
        action = "vim.lsp.buf.type_definition";
        options = {desc = "Goto t[y]pe definition";};
      }
      {
        mode = ["n"];
        key = "gD";
        action = "vim.lsp.buf.declaration";
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
