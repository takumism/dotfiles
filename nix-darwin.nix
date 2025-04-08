{ pkgs, ... }:
{
  system.stateVersion = 5;
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
    };
    casks = [
      "1password"
      "discord"
      "docker"
      "font-hack-nerd-font"
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

  # ref.https://github.com/nix-darwin/nix-darwin/tree/master/modules/system/defaults
  system = {
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Always";
        ## Keyboard
        KeyRepeat = 1;
        # Disable animation when opening and closing windows
        NSAutomaticWindowAnimationsEnabled = false;
        NSWindowResizeTime = 0.001;
        InitialKeyRepeat = 15;
        "com.apple.trackpad.scaling" = 1.5;
      };

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
    };

    # Mute a startup sound
    nvram.variables."StartupMute" = "%01";
  };
}

## Items that cannot be set in nix-darwin.
## Do not allow .DS_Store files to be created
# defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
## Use only UTF-8 in terminal
# defaults write com.apple.terminal StringEncodings -array 4
