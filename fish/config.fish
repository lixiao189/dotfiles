if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_greeting

#------------- default editor --------------------
set -gx EDITOR "nvim" 

#------------- path settings ---------------------
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH /opt/homebrew/sbin $PATH
set -gx PATH /opt/homebrew/opt/python@3.10/libexec/bin $PATH

#------------- alias settings --------------------
alias vim nvim
alias r ranger
alias lg lazygit
alias e exit
alias ls="exa -l --icons"
alias t 'tmux attach || tmux'
alias ts 'tmux source-file ~/.tmux.conf'
alias diff colordiff
alias td 'tmux detach'

#------------- pure settings ---------------------
set -gx pure_enable_single_line_prompt true 

#------------- proxy settings --------------------
set -x http_proxy 'http://127.0.0.1:7890'
set -x https_proxy 'http://127.0.0.1:7890'
set -x all_proxy 'socks5//127.0.0.1:7891'
