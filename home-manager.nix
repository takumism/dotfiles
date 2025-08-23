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
  home = {
    username = username;
    homeDirectory = lib.mkForce homeDirectory;
    stateVersion = "24.11";
    # dotfiles
    file = {
      ".config" = {
        source = ./.config;
        recursive = true;
      };
      ".Library/Application Support/Code/User/keybindings.json".source = ./vscode/keybindings.json;
      ".Library/Application Support/Code/User/settings.json".source = ./vscode/settings.json;
      ".gitconfig".source = ./.gitconfig;
      ".gitconfig.local".source = ./.gitconfig.local;
      ".zshrc".source = ./.zshrc;
      ".zsh" = {
        source = ./.zsh;
        recursive = true;
      };
    };
    # ref. https://search.nixos.org/packages
    packages = with pkgs; [
      # CLI
      _1password-cli
      awscli2
      aws-vault
      bash
      bat
      claude-code
      curl
      diff-so-fancy
      direnv
      expect
      eza
      fzf
      gh
      ghq
      go
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
      # fonts
      nerd-fonts.jetbrains-mono
    ];
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

  programs.home-manager.enable = true;
}
