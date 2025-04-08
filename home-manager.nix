{
  pkgs,
  username,
  platform,
  homeDirectory,
  rust-bin,
  lib,
  ...
}:
{
  programs.home-manager.enable = true;

  home = {
    username = username;
    homeDirectory = lib.mkForce homeDirectory;
    stateVersion = "24.11";
  };

  # ref. https://search.nixos.org/packages
  home.packages = with pkgs; [
    _1password-cli
    awscli2
    aws-vault
    bat
    curl
    diff-so-fancy
    expect
    eza
    fzf
    gh
    ghq
    git
    gnupg
    httpie
    jq
    lazygit
    mise
    neovim
    ranger
    ripgrep
    starship
    tree
    wget
    zellij
    zsh
  ]; 

  # dotfiles
  home.file = {
    ".config/git".source = ./.config/git;
    ".config/karabiner".source = ./.config/karabiner;
    ".config/starship.toml".source = ./.config/starship.toml;
    ".zshrc".source = ./.zshrc;
    ".zsh".source = ./.zsh;
    ".gitconfig".source = ./.gitconfig;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      cores = 0;
      trusted-users = [ username ];
    };

    gc = {
      automatic = true;
      frequency = "daily";
      options = "--delete-older-than 3d";
    };
  };
}
