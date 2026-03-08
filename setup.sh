#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"

# --- HELPER ---
link() {
  local src="$DOTFILES_DIR/$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
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

echo "==> Installing packages from Brewfile"
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "==> Installing Oh My Zsh (if missing)"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "==> Linking zsh plugins into Oh My Zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ln -sf "$(brew --prefix)/share/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
ln -sf "$(brew --prefix)/share/zsh-syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "==> Symlinking config files"
link zsh/.zshrc              "$HOME/.zshrc"
link git/config              "$HOME/.gitconfig"
link git/ignore              "$HOME/.gitignore_global"
link starship.toml           "$CONFIG_DIR/starship.toml"
link nvim                    "$CONFIG_DIR/nvim"
link ghostty                 "$CONFIG_DIR/ghostty"
link aerospace/aerospace.toml "$CONFIG_DIR/aerospace/aerospace.toml"
link kanata/kanata.kbd       "$CONFIG_DIR/kanata/kanata.kbd"

echo "==> Applying macOS defaults"
bash "$DOTFILES_DIR/macos/defaults.sh"

echo "==> Done! Restart your shell or run: source ~/.zshrc"
