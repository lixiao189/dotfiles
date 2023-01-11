# install zinit
/bin/bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
zinit self-update

# nvim packer install
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim


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
        brew install fzf && /opt/homebrew/opt/fzf/install
      
        brew install node
        brew install fd
        brew install gnu-sed
        brew install ripgrep
        brew install watchman
        brew install lazygit


        python3 -m pip install pynvim
    ;;
esac

ln -s ~/.dotfiles/zshrc ~/.zshrc
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/tmux/tmux.conf.local ~/.tmux.conf.local
ln -s ~/.dotfiles/alacritty ~/.config/alacritty
ln -s ~/.dotfiles/nvim ~/.config/nvim
