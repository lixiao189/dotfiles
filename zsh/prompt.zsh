# user@host ~/path branch[*][ ↑N][:action] (venv) ✦jobs exit >

autoload -Uz add-zsh-hook vcs_info

setopt PROMPT_SUBST TRANSIENT_RPROMPT

# Show the venv name ourselves instead of letting activate rewrite PROMPT.
export VIRTUAL_ENV_DISABLE_PROMPT=1

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes false
zstyle ':vcs_info:git:*' formats ' %F{magenta}%b%m%f'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}%b%m%f:%F{red}%a%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-status

# Append (via %m) '*' for any uncommitted change (staged, unstaged or
# untracked) and ' ↑N' for commits the upstream doesn't have yet.
+vi-git-status() {
  local ahead
  [[ -n $(command git status --porcelain 2>/dev/null | head -n1) ]] && hook_com[misc]+='*'
  ahead=$(command git rev-list --count '@{upstream}..HEAD' 2>/dev/null)
  (( ahead )) && hook_com[misc]+=" ↑${ahead}"
  return 0   # a non-zero return would skip the remaining hooks
}

_prompt_precmd() {
  local rc=$?
  _prompt_venv=${VIRTUAL_ENV:+" %F{cyan}(${VIRTUAL_ENV:t})%f"}
  vcs_info
  # Terminal title: cwd (and command while running, see preexec below).
  print -Pn '\e]2;%~\a'
  return $rc
}
_prompt_title_preexec() { print -Pn "\e]2;${1[1,40]//[[:cntrl:]]/} — %~\a" }

# Report cwd to the terminal (OSC 7), percent-encoded.
_prompt_osc7() {
  setopt localoptions extendedglob no_multibyte
  local c hex url
  for c in ${(s::)PWD}; do
    if [[ $c == [A-Za-z0-9/._~-] ]]; then url+=$c
    else printf -v hex '%%%02X' "'$c"; url+=$hex; fi
  done
  print -n "\e]7;file://${HOST}${url}\e\\"
}

add-zsh-hook preexec _prompt_title_preexec
add-zsh-hook precmd  _prompt_precmd
add-zsh-hook precmd  _prompt_osc7

PROMPT2='%F{8}...%f '

PROMPT='%B%F{blue}%n@%m%f%b %B%F{white}%3~%f%b${vcs_info_msg_0_}'
PROMPT+='${_prompt_venv}'
PROMPT+='%(1j. %F{yellow}✦%j%f.)'
PROMPT+='%(?.. %F{red}%?%f)'
PROMPT+=' %(?.%F{green}.%F{red})%(!.#.>)%f '
