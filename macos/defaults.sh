#!/bin/bash
set -e

echo "==> Configuring macOS defaults"

# ─── Trackpad ────────────────────────────────────────────
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true            # Tap to click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true   # Two-finger tap for right click
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true  # Three-finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.5             # Tracking speed

# ─── Keyboard ────────────────────────────────────────────
defaults write NSGlobalDomain KeyRepeat -int 2                                  # Faster key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15                          # Shorter delay before repeat
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false   # Disable auto-correct
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false       # Disable auto-capitalize
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false   # Disable period on double-space
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false    # Disable smart quotes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false     # Disable smart dashes

# ─── Dock ────────────────────────────────────────────────
defaults write com.apple.dock autohide -bool true                               # Auto-hide the Dock
defaults write com.apple.dock autohide-delay -float 0                           # No delay before showing
defaults write com.apple.dock autohide-time-modifier -float 0.3                 # Faster hide/show animation
defaults write com.apple.dock tilesize -int 48                                  # Smaller icon size
defaults write com.apple.dock show-recents -bool false                          # Hide recent apps

# ─── Finder ──────────────────────────────────────────────
defaults write NSGlobalDomain AppleShowAllExtensions -bool true                 # Show file extensions
defaults write com.apple.finder AppleShowAllFiles -bool true                    # Show hidden files
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"             # Default to list view
defaults write com.apple.finder ShowPathbar -bool true                          # Show path bar
defaults write com.apple.finder ShowStatusBar -bool true                        # Show status bar
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"             # Search current folder by default

# ─── Screenshots ─────────────────────────────────────────
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"     # Save to ~/Screenshots
defaults write com.apple.screencapture disable-shadow -bool true                # Disable window shadow

# ─── Appearance ──────────────────────────────────────────
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"                # Dark mode
osascript -e 'tell application "System Events" to set picture of every desktop to POSIX file "/System/Library/Desktop Pictures/Solid Colors/Black.png"'  # Black wallpaper

# ─── Screen Saver ────────────────────────────────────────
defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName -string "Computer Name" path -string "/System/Library/Frameworks/ScreenSaver.framework/PlugIns/BlankScreen.saver" type -int 0  # Blank (black) screen saver

# ─── Misc ────────────────────────────────────────────────
defaults write com.apple.LaunchServices LSQuarantine -bool false                # Disable "open this app?" dialog
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true     # Expand save dialog by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true        # Expand print dialog by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# ─── Restart affected apps ───────────────────────────────
killall Dock Finder SystemUIServer 2>/dev/null || true

echo "==> macOS defaults applied. Some changes require a logout or restart."
