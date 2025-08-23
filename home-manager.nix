{
  pkgs,
  lib,
  ...
}:
{
  home = {
    # username / homeDirectory are set automatically by home-manager.
    stateVersion = "25.11";

    # home.file is used for files that should be placed in the home directory.
    file = lib.mapAttrs (name: type: {
      source = ./homefiles + "/${name}";
      recursive = type == "directory";
    }) (builtins.readDir ./homefiles);

    # ref. https://search.nixos.org/packages
    packages = with pkgs; [
      # CLI
      _1password-cli
      aerospace
      atuin
      aws-vault
      awscli2
      bat
      claude-code
      curl
      delta
      direnv
      eza
      fd
      fzf
      gh
      ghq
      git
      gnused
      jq
      lazygit
      mise
      neovim
      procs
      ripgrep
      starship
      wget
      yazi
      zellij
      zoxide
      zsh

      # Fonts
      nerd-fonts.jetbrains-mono
      udev-gothic-nf
    ];
  };

  # xdg.configFile is used for config files that should be placed in ~/.config.
  xdg.configFile = lib.mapAttrs (name: type: {
    source = ./configfiles + "/${name}";
    recursive = type == "directory";
  }) (builtins.readDir ./configfiles);

  programs.home-manager.enable = true;
}
