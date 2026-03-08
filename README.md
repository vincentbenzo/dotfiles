# dotfiles

My macOS development environment, managed from `~/.config`.

## What's included

- **Ghostty** — terminal emulator
- **Zsh** + Oh My Zsh + Starship prompt
- **Neovim** — editor config
- **AeroSpace** — tiling window manager
- **Kanata** — keyboard remapping
- **Git** — global git config
- **Brewfile** — all packages, casks, and fonts

## Setup

```bash
git clone https://github.com/vincentbenzo/dotfiles.git ~/.config
cd ~/.config
chmod +x setup.sh
./setup.sh
```

The setup script will:

1. Install Homebrew (if missing)
2. Install all packages from the Brewfile
3. Install Oh My Zsh (if missing)
4. Link zsh plugins and symlink `.zshrc`
