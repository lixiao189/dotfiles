# install zinit
/bin/bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
zinit self-update

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
        brew install tmux
        brew install ranger
        brew install bat
        brew install exa
     
        brew install python@3.11 
        brew install node
        brew install go 
        brew install openjdk
        brew install maven
        brew install fd
        brew install gnu-sed
        brew install ripgrep
        brew install watchman
        brew install colordiff
        brew install lazygit

        python3 -m pip install pynvim
    ;;
esac

ln -s ~/.dotfiles/zshrc ~/.zshrc
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/tmux/tmux.conf.local ~/.tmux.conf.local
ln -s ~/.dotfiles/alacritty ~/.config/alacritty
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/karabiner ~/.config/karabiner
ln -s ~/.dotfiles/ranger ~/.config/ranger
