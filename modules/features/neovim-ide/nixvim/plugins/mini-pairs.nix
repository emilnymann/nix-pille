_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim = {
      plugins.mini-pairs = {
        enable = true;
        settings = {
          modes = {
            insert = true;
            command = false;
            terminal = false;
          };

          mappings = {
            "(" = {
              action = "open";
              pair = "()";
              neigh_pattern = "^[^\\][^%w%%%'%[%\"%.%`%$]";
            };

            "[" = {
              action = "open";
              pair = "[]";
              neigh_pattern = "^[^\\][^%w%%%'%[%\"%.%`%$]";
            };

            "{" = {
              action = "open";
              pair = "{}";
              neigh_pattern = "^[^\\][^%w%%%'%[%\"%.%`%$]";
            };

            "\"" = {
              action = "closeopen";
              pair = "\"\"";
              neigh_pattern = "^[^\\][^%w%%%'%[%\"%.%`%$]";
              register = {cr = false;};
            };

            "'" = {
              action = "closeopen";
              pair = "''";
              neigh_pattern = "^[^%a\\][^%w%%%'%[%\"%.%`%$]";
              register = {cr = false;};
            };

            "`" = {
              action = "closeopen";
              pair = "``";
              neigh_pattern = "^[^\\][^%w%%%'%[%\"%.%`%$]";
              register = {cr = false;};
            };
          };
        };
      };
    };
  };
}
