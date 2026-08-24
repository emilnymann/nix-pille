_: {
  flake.homeModules.file-browser = {pkgs, ...}: {
    programs.yazi = {
      plugins = {
        compress = pkgs.yaziPlugins.compress;
      };

      keymap.mgr.prepend_keymap = [
        {
          on = ["c" "a" "a"];
          run = "plugin compress";
          desc = "Archive selected files";
        }
        {
          on = ["c" "a" "p"];
          run = "plugin compress -p";
          desc = "Archive selected files (password)";
        }
      ];
    };
  };
}
