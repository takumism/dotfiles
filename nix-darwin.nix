{ pkgs, ... }:
{
  # Use zsh in Nix packages.
  environment.shells = [ pkgs.zsh pkgs.bash ];
  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
    };
    casks = [
      # GUI
      "1password"
      "claude"
      "discord"
      "docker"
      "google-chrome"
      "google-japanese-ime"
      "ghostty"
      "intellij-idea-ce"
      "karabiner-elements"
      "obsidian"
      "onyx"
      "raycast"
      "slack"
      "spotify"
      "the-unarchiver"
      "visual-studio-code"
      "vlc"
      "zoom"
    ];
  };

  # ref.https://nix-darwin.github.io/nix-darwin/manual/index.html
  system = {
    # Items that cannot be set in nix-darwin.
    activationScripts.configurations.text = ''
      # Disable Quick Look window animation
      defaults write -g QLPanelAnimationDuration -float 0
      # Disable dashboard
      defaults write com.apple.dashboard mcx-disabled -bool true
      # Do not allow .DS_Store files to be created
      defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
      defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
      # Use only UTF-8 in terminal
      defaults write com.apple.terminal StringEncodings -array 4
    '';

    defaults = {
      controlcenter = {
        BatteryShowPercentage = true;
        # Display icon in menu bar.
        Bluetooth = true;
        # Hide icon in menu bar.
        AirDrop = false;
      };

      finder = {
        AppleShowAllFiles = false;
        QuitMenuItem = true;
        ShowStatusBar = true;
        ShowPathbar = true;
        # Put directories in front of sort by name when selecting sort by name
        _FXSortFoldersFirst = true;
      };

      dock = {
        autohide = true;
        launchanim = false;
        mineffect = "scale";
        minimize-to-application = true;
        # Reorder desktops based on usage
        mru-spaces = false;
        orientation = "right";
        # Wipe all app icons from the dock
        persistent-apps = [];
        show-recents = false;
        # Magnify icons on hover
        magnification = true;
        largesize = 48;
        tilesize = 36;
      };

      ".GlobalPreferences"."com.apple.mouse.scaling" = 2.5;

      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 1; # Always;
        ShowSeconds = true;
      };

      # Accelerate window size adjustment
      NSGlobalDomain.NSWindowResizeTime = 0.001;
    };

    # Mute a startup sound
    nvram.variables."StartupMute" = "%01";

    stateVersion = 5;
  };
}
