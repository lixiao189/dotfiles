#!/bin/bash

# Install the dependencies on Mac
case $(uname) in
    Darwin)
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
     
        brew tap --custom-remote --force-auto-update homebrew/cask https://github.com/Homebrew/homebrew-cask
        brew install git
        brew tap homebrew/cask-fonts
        brew install font-caskaydia-cove-nerd-font

        brew install iterm2
        brew install karabiner-elements
       
        brew install tree-sitter
        brew install nvim
        brew install fish 
        brew install tmux
        brew install ranger
        brew install exa
     
        brew install python@3.11 
        brew install node
        brew install ripgrep
        brew install gnu-sed 
        brew install entr
        brew install dust
        brew install dog
        brew install colordiff
        brew install lazygit
    ;;
esac

ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/alacritty ~/.config/alacritty
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/wezterm.lua ~/.wezterm.lua
ln -s ~/.dotfiles/karabiner ~/.config/karabiner
ln -s ~/.dotfiles/ranger ~/.config/ranger
ln -s ~/.dotfiles/omf/ ~/.config/omf
ln -s ~/.dotfiles/mpv/ ~/.config/mpv

# Install devicons for ranger 
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

# oh my fish installation
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

# install tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Setup vim
mkdir -p ~/.vim
ln -s ~/.dotfiles/vimrc ~/.vim/vimrc
ln -s ~/.dotfiles/coc-settings.json ~/.vim/coc-settings.json

# Setup the rime config file
git clone https://github.com/iDvel/rime-ice.git
ln -s ~/.dotfiles/rime/default.custom.yaml ~/Library/Rime
ln -s ~/.dotfiles/rime/squirrel.custom.yaml ~/Library/Rime
