_: {
  flake.homeModules.tridactyl =
    { pkgs, ... }:
    {
      programs.firefox = {
        policies.ExtensionSettings = {
          "tridactyl.vim.betas@cmcaine.co.uk" = {
            install_url = "https://tridactyl.cmcaine.co.uk/betas/tridactyl-latest.xpi";
            installation_mode = "normal_installed";
          };
        };
        nativeMessagingHosts = with pkgs; [
          tridactyl-native
        ];
      };

      xdg.configFile."tridactyl/tridactylrc".text = ''
        " - SCROLL -
        set smoothscroll true



        " - TABS -
        unbind --mode=normal H
        unbind --mode=normal L
        unbind --mode=normal <Space>bd
        unbind --mode=normal <Space>bo

        bind --mode=normal H tabprev
        bind --mode=normal L tabnext
        bind --mode=normal <Space>bd tabclose
        bind --mode=normal <Space>bo composite tabcloseallto left | tabcloseallto right



        " - HISTORY -
        unbind --mode=browser <C-h>
        unbind --mode=browser <C-l>

        bind --mode=normal <C-h> back
        bind --mode=normal <C-l> forward



        " - INCSEARCH -
        set findcase "smart"

        unbind --mode=normal /
        unbind --mode=normal ?
        unbind --mode=normal n
        unbind --mode=normal N

        bind --mode=normal / fillcmdline find
        bind --mode=normal ? fillcmdline find --reverse
        bind --mode=normal n findnext --search-from-view
        bind --mode=normal N findnext --search-from-view --reverse
        bind --mode=normal <esc> nohlsearch



        " - OPEN -
        unbind --mode=normal o
        unbind --mode=normal O

        bind --mode=normal o fillcmdline open
        bind --mode=normal O fillcmdline tabopen
      '';
    };
}
