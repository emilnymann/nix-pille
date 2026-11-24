_: {
  flake.homeModules.ens = _: {
    programs.ghostty = {
      clearDefaultKeybinds = true;
      settings.keybind = [
        "super+c=copy_to_clipboard"
        "super+v=paste_from_clipboard"
        "super+w=close_window"
        "super+q=quit"
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"

        "vim/"
        "ctrl+g=activate_key_table:vim"
        "vim/ctrl+g=deactivate_key_table"

        "vim/shift+h=previous_tab"
        "vim/shift+l=next_tab"
        "vim/t>n=new_tab"
        "vim/t>d=close_tab"

        "vim/ctrl+h=goto_split:left"
        "vim/ctrl+l=goto_split:right"
        "vim/w>s=new_split:right"
        "vim/w>shift+s=new_split:down"
        "vim/w>d=close_surface"
      ];
    };
  };
}
