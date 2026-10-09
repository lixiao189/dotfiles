alias v=nvim
alias s='kitty +kitten ssh'

alias ls='ls -G'
alias ll='ls -lh'
alias l='ls -lah'
alias la='ls -lAh'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# yazi: cd into the directory yazi was in when it exited.
y() {
  local tmp cwd
  tmp=$(mktemp -t "yazi-cwd.XXXXXX")
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n $cwd && $cwd != $PWD ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
