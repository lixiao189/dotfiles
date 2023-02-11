set -g fish_greeting

#------------- default editor --------------------
set -gx EDITOR "nvim" 

#------------- path settings ---------------------
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH /opt/homebrew/sbin $PATH
set -gx PATH /opt/homebrew/opt/python@3.10/libexec/bin $PATH
set -gx PATH github/copilot.vim $PATH

#------------- alias settings --------------------
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
#------------- brew settings ---------------------
set -gx HOMEBREW_BREW_GIT_REMOTE "https://mirrors.ustc.edu.cn/brew.git"
set -gx HOMEBREW_CORE_GIT_REMOTE "https://mirrors.ustc.edu.cn/homebrew-core.git"
set -gx HOMEBREW_BOTTLE_DOMAIN "https://mirrors.ustc.edu.cn/homebrew-bottles"

#------------- proxy settings --------------------
set -gx http_proxy 'http://127.0.0.1:7890'
set -gx https_proxy 'http://127.0.0.1:7890'
set -gx all_proxy 'socks5//127.0.0.1:7891'

#------------- theme settings --------------------
set theme_primary                                   1eb980
set theme_secondary                                 006af0
set theme_primary_variant                           045d56
set theme_secondary_variant                         555870
set theme_hilight                                   b15dff

set -g theme_color_user                             $theme_hilight
set -g theme_color_host                             $theme_primary_variant
set -g theme_color_separator                        brblack
set -g theme_color_normal                           normal
set -g theme_color_time                             $theme_secondary_variant
set -g theme_color_path                             $theme_primary
set -g theme_color_prompt                           $theme_secondary_variant
set -g theme_color_virtualenv                       $theme_secondary
set -g theme_color_status_prefix                    $theme_hilight
set -g theme_color_status_jobs                      $theme_primary
set -g theme_display_group                          no
set -g theme_prompt_segment_separator_color         $theme_primary
set -g theme_prompt_userhost_separator              '@'
set -g __fish_git_prompt_char_branch_begin          '['
set -g __fish_git_prompt_char_branch_end            ']'
set -g __fish_git_prompt_color_branch_begin         brblack
set -g __fish_git_prompt_color_branch_end           brblack
set -g __fish_git_prompt_color_branch               $theme_secondary

set -g theme_display_rw no
