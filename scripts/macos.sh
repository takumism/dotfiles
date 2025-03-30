#!/bin/sh

##### Setup script for macOS #####

if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

# Command Line Tools
echo "==> Start to install command Line Tools."
sudo xcode-select --install > /dev/null
echo "==> Command Line Tools are installed."

# Rosseta
echo "==> Start to install Rosetta."
sudo softwareupdate --install-rosetta --agree-to-license > /dev/null
echo "==> Rosseta is installed."

# Shell
chsh -s /bin/zsh
echo "==> Set zsh as the default shell"

# Homebrew
echo "==> Start to install Homebrew."
xcode-select --install > /dev/null
if ! (type "brew" > /dev/null 2>&1); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null
fi
echo "==> Homebrew is installed."

echo "==> Start MacOS setup"
# Disable start up sound
sudo nvram StartupMute=%01
# -----------------------------------------------
# Finder
# -----------------------------------------------
sudo chflags nohidden ~/Library
# Show all file name extensions
defaults write com.apple.finder AppleShowAllExtensions -bool true
# Do not show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool false
# Add a quit option to the Finder
defaults write com.apple.Finder QuitMenuItem -bool true
# Show bars
defaults write com.apple.finder ShowToolbar -bool true
defaults write com.apple.finder ShowTabView -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
# Disable animations
defaults write com.apple.finder DisableAllAnimations -bool true
# Put directories in front of sort by name when selecting sort by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# -----------------------------------------------
# Dock
# -----------------------------------------------
# Disable the animation when openning applications
defaults write com.apple.dock launchanim -bool false
# Automatically hide or show the Dock
defaults write com.apple.dock autohide -bool true
# Wipe all app icons from the Dock
defaults write com.apple.dock persistent-apps -array
# Icons
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 48
defaults write com.apple.dock tilesize -int 36
# Position on Screen
defaults write com.apple.dock orientation -string right
# Recently used apps
defaults write com.apple.dock show-recents -bool false
# No apps can be added or removed from the Dock
defaults write com.apple.dock contents-immutable -boolean true

# -----------------------------------------------
# Mission Controll
# -----------------------------------------------
defaults write com.apple.dock mru-spaces -bool true

# -----------------------------------------------
# Menubar
# -----------------------------------------------
# Automatically hide and show the menu bar in full screen
defaults write -g AppleMenuBarVisibleInFullscreen -bool true
# Show Bluetooth option in menubar
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
# # Display date, day, and time in the menu bar
defaults write com.apple.menuextra.clock DateFormat -string 'EEE d MMM HH:mm:ss'
# Display battery level in the menu bar
defaults write com.apple.menuextra.battery ShowPercent -bool true

# -----------------------------------------------
# Keyboard & Mouse
# -----------------------------------------------
# Faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Faster mouse speed
defaults write -g com.apple.mouse.scaling 3
defaults write -g com.apple.trackpad.scaling 1.5

# -----------------------------------------------
# Audio
# -----------------------------------------------
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 48
defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" 40

# -----------------------------------------------
# Dialog
# -----------------------------------------------
# Disable crash report
defaults write com.apple.CrashReporter DialogType -string "none"    
# Disable dialog when running unidentified applications
defaults write com.apple.LaunchServices LSQuarantine -bool false 
# Disable warning dialog when opening downloaded files
defaults write com.apple.LaunchServices LSQuarantine -bool false

# -----------------------------------------------
# Others
# -----------------------------------------------
# Always display scrollbars
defaults write -g AppleShowScrollBars -string "Always"
# Disable animation when opening and closing windows
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
#　Accelerate window size adjustment
defaults write -g NSWindowResizeTime -float 0.001
# Disable Quick Look window animation
defaults write -g QLPanelAnimationDuration -float 0
# Disable dashboard
defaults write com.apple.dashboard mcx-disabled -bool true
# Do not allow .DS_Store files to be created
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Use only UTF-8 in terminal
defaults write com.apple.terminal StringEncodings -array 4

# Restart the apps
for app in "Finder" \
    "Dock" \
	"SystemUIServer"; do
	killall "${app}" > /dev/null
done

# Install packages with Homebrew.
/opt/homebrew/bin/brew bundle --global --no-lock
# Install fzf key bindings & auto-completion.
echo 'y' | /opt/homebrew/opt/fzf/install

echo "==> Done."
exec $SHELL -l
