# Native zsh prompt, single line (no framework, no external processes):
#   user@host ~/path branch[:action] (venv) ✦jobs exit >
# Git info via vcs_info reading .git directly (no dirty check, so big repos stay
# fast). Colours use %F/%f so zsh counts widths correctly. Root gets '#'.

autoload -Uz add-zsh-hook vcs_info

setopt PROMPT_SUBST TRANSIENT_RPROMPT

# Show the venv name ourselves instead of letting activate rewrite PROMPT.
export VIRTUAL_ENV_DISABLE_PROMPT=1

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes false
zstyle ':vcs_info:git:*' formats ' %F{magenta}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}%b%f:%F{red}%a%f'

_prompt_precmd() {
  local rc=$?
  _prompt_venv=${VIRTUAL_ENV:+" %F{cyan}(${VIRTUAL_ENV:t})%f"}
  vcs_info
  # Terminal title: cwd (and command while running, see preexec below).
  print -Pn '\e]2;%~\a'
  return $rc
}
_prompt_title_preexec() { print -Pn "\e]2;${1[1,40]//[[:cntrl:]]/} — %~\a" }

add-zsh-hook preexec _prompt_title_preexec
add-zsh-hook precmd  _prompt_precmd

# Continuation / selection prompts.
PROMPT2='%F{8}...%f '

# Colour scheme: user@host blue, path white, branch magenta, venv cyan,
# background job count yellow, non-zero exit code red; the prompt symbol is
# green on success and red after a failed command.
PROMPT='%B%F{blue}%n@%m%f%b %B%F{white}%3~%f%b${vcs_info_msg_0_}'
PROMPT+='${_prompt_venv}'
PROMPT+='%(1j. %F{yellow}✦%j%f.)'
PROMPT+='%(?.. %F{red}%?%f)'
PROMPT+=' %(?.%F{green}.%F{red})%(!.#.>)%f '
