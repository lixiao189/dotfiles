set -g fish_greeting

#------------- default editor --------------------
set -gx EDITOR "nvim" 

#------------- path settings ---------------------
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH /opt/homebrew/sbin $PATH
set -gx PATH /opt/homebrew/opt/python@3.10/libexec/bin $PATH
set -gx PATH github/copilot.vim $PATH

#------------- command shortcuts -----------------
alias nv nvim
alias r ranger
alias lg lazygit
alias e exit
alias ls "exa -l --icons"
alias ts 'tmux source-file ~/.tmux.conf'
alias diff colordiff

alias t 'tmux attach || tmux new-session'
alias ta 'tmux attach -t'
alias tn 'tmux new-session'
alias tl 'tmux list-sessions'
alias td 'tmux detach'

function ide
    tmux split-window -v -p 30
    tmux split-window -h -p 66
    tmux split-window -h -p 50
end
#------------- brew settings ---------------------
set -gx HOMEBREW_API_DOMAIN "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
set -gx HOMEBREW_BOTTLE_DOMAIN "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
set -gx HOMEBREW_BREW_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
set -gx HOMEBREW_CORE_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
set -gx HOMEBREW_PIP_INDEX_URL "https://pypi.tuna.tsinghua.edu.cn/simple"
