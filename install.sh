# install zinit
/bin/bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
zinit self-update

# Install the dependencies on Mac
case $(uname) in
    Darwin)
        xcode-select --install
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
     
        brew tap --custom-remote --force-auto-update homebrew/cask https://github.com/Homebrew/homebrew-cask
        brew install git 
        brew tap homebrew/cask-fonts
        brew install font-fira-code-nerd-font

        brew install tmux
        brew install alacritty
        
        brew install nvim
        brew install bat
        brew install exa
    ;;
esac

ln -s ~/.dotfiles/zshrc .zshrc
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/tmux/tmux.conf.local ~/.tmux.conf.local
