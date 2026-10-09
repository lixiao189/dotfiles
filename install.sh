#!/usr/bin/env bash
# Bootstrap a macOS machine from ~/.dotfiles. Safe to re-run.
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

link() { # link <source> <target>
    mkdir -p "$(dirname "$2")"
    ln -sfn "$1" "$2"
    echo "linked $2 -> $1"
}

install_packages() {
    if ! command -v brew >/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    brew install git neovim vim zoxide fzf fd ripgrep fnm lazygit tree-sitter \
        font-jetbrains-mono-nerd-font
    brew install --cask wezterm ghostty squirrel-app
}

install_packages_if_darwin() {
    [[ $(uname) == Darwin ]] || { echo "only macOS is supported" >&2; exit 1; }
    install_packages
}

link_configs() {
    link "$DOTFILES/nvim"          ~/.config/nvim
    link "$DOTFILES/ghostty"       ~/.config/ghostty
    link "$DOTFILES/wezterm.lua"   ~/.wezterm.lua
    link "$DOTFILES/vimrc"         ~/.vim/vimrc
    link "$DOTFILES/coc-settings.json" ~/.vim/coc-settings.json
    link "$DOTFILES/zsh/zshrc"     ~/.zshrc
}

setup_rime() {
    local ice=~/.local/share/rime-ice
    [[ -d $ice ]] || git clone --depth 1 https://github.com/iDvel/rime-ice.git "$ice"
    mkdir -p ~/Library/Rime
    rsync -a --exclude .git "$ice"/ ~/Library/Rime/
    link "$DOTFILES/rime/default.custom.yaml"  ~/Library/Rime/default.custom.yaml
    link "$DOTFILES/rime/squirrel.custom.yaml" ~/Library/Rime/squirrel.custom.yaml
}

install_packages_if_darwin
link_configs
setup_rime
# zsh plugins (zinit) bootstrap themselves on first shell start.
