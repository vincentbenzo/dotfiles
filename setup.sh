#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"

# --- HELPER ---
link() {
  local src="$DOTFILES_DIR/$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  rm -rf "$dest"
  ln -s "$src" "$dest"
  echo "    Linked $dest -> $src"
}

echo "==> Installing Homebrew (if missing)"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "==> Updating Homebrew"
brew update

echo "==> Tapping required repositories"
brew tap common-fate/granted
brew tap common-fate/tap
brew tap infisical/get-cli
brew tap nikitabobko/tap
brew tap FelixKratz/formulae

echo "==> Installing packages from Brewfile"
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "==> Installing Oh My Zsh (if missing)"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "==> Cloning zsh plugins into Oh My Zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] || \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "==> Symlinking config files"
link zsh/.zshrc              "$HOME/.zshrc"
link git/config              "$HOME/.gitconfig"
link git/ignore              "$HOME/.gitignore_global"
link sketchybar              "$CONFIG_DIR/sketchybar"

echo "==> Setting up Kanata (keyboard remapping)"
KARABINER_PKG_VERSION="6.2.0"
KARABINER_MANAGER="/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"
KARABINER_DAEMON="/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"

if [ ! -f "$KARABINER_MANAGER" ]; then
  echo "    Installing Karabiner Virtual HID Driver v$KARABINER_PKG_VERSION"
  curl -fsSL -o /tmp/karabiner-driver.pkg \
    "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v${KARABINER_PKG_VERSION}/Karabiner-DriverKit-VirtualHIDDevice-${KARABINER_PKG_VERSION}.pkg"
  sudo installer -pkg /tmp/karabiner-driver.pkg -target /
  rm /tmp/karabiner-driver.pkg
fi

echo "    Activating Karabiner driver extension"
"$KARABINER_MANAGER" activate

echo "    Installing LaunchDaemons for Karabiner and Kanata"
sudo cp "$DOTFILES_DIR/kanata/com.karabiner.daemon.plist" /Library/LaunchDaemons/
sudo chown root:wheel /Library/LaunchDaemons/com.karabiner.daemon.plist
sudo chmod 644 /Library/LaunchDaemons/com.karabiner.daemon.plist

sudo cp "$DOTFILES_DIR/kanata/com.kanata.daemon.plist" /Library/LaunchDaemons/
sudo chown root:wheel /Library/LaunchDaemons/com.kanata.daemon.plist
sudo chmod 644 /Library/LaunchDaemons/com.kanata.daemon.plist

# Bootstrap daemons (ignore errors if already loaded)
sudo launchctl bootstrap system /Library/LaunchDaemons/com.karabiner.daemon.plist 2>/dev/null || true
sudo launchctl bootstrap system /Library/LaunchDaemons/com.kanata.daemon.plist 2>/dev/null || true

echo "    NOTE: You must approve the Karabiner driver extension in"
echo "    System Settings > General > Login Items & Extensions > Driver Extensions"
echo "    Then add kanata (/opt/homebrew/bin/kanata) to"
echo "    System Settings > Privacy & Security > Input Monitoring"
echo "    A reboot is required after approving the driver."

echo "==> Applying macOS defaults"
bash "$DOTFILES_DIR/macos/defaults.sh"

echo "==> Done! Restart your shell or run: source ~/.zshrc"
