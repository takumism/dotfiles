{ pkgs, username, ... }:
{
  # Enable Determinate Nix integration. Required: without this flag, Determinate Nix
  # and nix-darwin's built-in Nix management conflict.
  determinateNix.enable = true;

  # Use zsh in Nix packages.
  environment.shells = [ pkgs.zsh pkgs.bash ];
  programs.zsh.enable = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # Manage Nix daemon settings from nix-darwin (via Determinate integration).
  # These are written to /etc/nix/nix.custom.conf.
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      username
      "@admin"
    ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # Uninstall anything removed from the `casks` list.
      cleanup = "uninstall";
    };
    casks = [
      # GUI
      "1password"
      "claude"
      "discord"
      "google-chrome"
      "google-japanese-ime"
      "ghostty"
      "intellij-idea-ce"
      "karabiner-elements"
      "obsidian"
      "orbstack"
      "raycast"
      "slack"
      "spotify"
      "visual-studio-code"
      "vlc"
    ];
  };

  # ref.https://nix-darwin.github.io/nix-darwin/manual/index.html
  system = {
    defaults = {
      # Settings without dedicated nix-darwin options.
      CustomUserPreferences = {
        NSGlobalDomain = {
          # Disable Quick Look window animation.
          QLPanelAnimationDuration = 0;
        };
        "com.apple.dashboard" = {
          # Disable dashboard.
          "mcx-disabled" = true;
        };
        "com.apple.desktopservices" = {
          # Do not allow .DS_Store files to be created on network / USB drives.
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.terminal" = {
          # Use only UTF-8 in Terminal.app.
          StringEncodings = [ 4 ];
        };
      };

      controlcenter = {
        BatteryShowPercentage = true;
        # Display icon in menu bar.
        Bluetooth = true;
        # Hide icon in menu bar.
        AirDrop = false;
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false;
        QuitMenuItem = true;
        ShowStatusBar = true;
        ShowPathbar = true;
        # Put directories in front of sort by name when selecting sort by name
        _FXSortFoldersFirst = true;
      };

      # Keep the Dock completely empty: no pinned apps (`persistent-apps = []`)
      # and no recently-used apps (`show-recents = false`).
      dock = {
        autohide = true;
        launchanim = false;
        mineffect = "scale";
        minimize-to-application = true;
        # Reorder desktops based on usage.
        mru-spaces = false;
        orientation = "right";
        persistent-apps = [];
        show-recents = false;
        # Magnify icons on hover.
        magnification = true;
        largesize = 48;
        tilesize = 36;
        # Group windows by application with Mission Control.
        expose-group-apps = true;
      };

      ".GlobalPreferences"."com.apple.mouse.scaling" = 2.5;

      loginwindow = {
        GuestEnabled = false;
      };

      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 1; # Always;
        ShowSeconds = true;
      };

      # Accelerate window size adjustment
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark"; # ダークモード
        NSWindowResizeTime = 0.001;
        # Use fn keys as standard fn keys (instead of media keys)
        "com.apple.keyboard.fnState" = true;
      };
    };

    # Mute the startup sound. "%01" is the NVRAM binary representation of `true`.
    nvram.variables."StartupMute" = "%01";

    primaryUser = username;

    stateVersion = 5;
  };
}
