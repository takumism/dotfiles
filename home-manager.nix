{
  pkgs,
  lib,
  ...
}:
{
  home = {
    username = "takumism";
    homeDirectory = "/Users/takumism";
    stateVersion = "25.11";

    # home.file is used for files that should be placed in the home directory.
    file = lib.mapAttrs (name: type: {
      source = ./homefiles + "/${name}";
      recursive = type == "directory";
    }) (builtins.readDir ./homefiles);

    # Keep nixpkgs as a small bootstrap layer. Developer tools and optional CLIs
    # belong in mise to avoid slow Nix builds and large store closures.
    # ref. https://search.nixos.org/packages
    packages = with pkgs; [
      # Bootstrap CLI
      _1password-cli
      aerospace
      curl
      direnv
      git
      gnused
      mise
      starship
      wget
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
