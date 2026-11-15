_: {
  flake.homeModules.neovim-ide = _: {
    programs.nixvim.plugins.lualine.settings.sections.lualine_z = [
      {
        __unkeyed-1.__raw = ''function() return require("noice").api.status.command.get() end'';
        cond.__raw = ''function() return package.loaded["noice"] and require("noice").api.status.command.has() end'';
        color.__raw = ''function() return { fg = Snacks.util.color("Statement") } end'';
      }
    ];
  };
}
