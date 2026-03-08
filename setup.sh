#!/bin/bash
set -e

echo "==> Installing Homebrew (if missing)"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "==> Installing packages from Brewfile"
brew bundle --file="$(dirname "$0")/Brewfile"

echo "==> Installing Oh My Zsh (if missing)"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "==> Linking zsh plugins into Oh My Zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Link brew-installed plugins into oh-my-zsh custom dir
ln -sf "$(brew --prefix)/share/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
ln -sf "$(brew --prefix)/share/zsh-syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "==> Symlinking .zshrc"
ln -sf ~/.config/zsh/.zshrc ~/.zshrc

echo "==> Applying macOS defaults"
bash "$(dirname "$0")/macos/defaults.sh"

echo "==> Done! Restart your shell or run: source ~/.zshrc"
