#!/bin/bash

# Install the dependencies on Mac
case $(uname) in
    Darwin)
        brew install nvim
        brew install tmux
				brew install yazi
        brew install ripgrep
        brew install lazygit
				brew install imagemagick
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
ln -s ~/.dotfiles/vimrc ~/.vimrc

# Setup the rime config file
git clone https://github.com/iDvel/rime-ice.git
ln -s ~/.dotfiles/rime/default.custom.yaml ~/Library/Rime
ln -s ~/.dotfiles/rime/squirrel.custom.yaml ~/Library/Rime
