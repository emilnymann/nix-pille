_: {
  flake.homeModules.tridactyl = _: {
    programs.firefox.policies.ExtensionSettings = {
      "tridactyl.vim.betas@cmcaine.co.uk" = {
        install_url = "https://tridactyl.cmcaine.co.uk/betas/tridactyl-latest.xpi";
        installation_mode = "normal_installed";
      };
    };
  };
}
