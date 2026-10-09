# Native zsh prompt, single line (no framework, no external processes):
#   user@host ~/path branch[:action] 12s >
# Git info via vcs_info reading .git directly (no dirty check, so big repos stay
# fast). Colours use %F/%f so zsh counts widths correctly. Root gets '#'.

autoload -Uz add-zsh-hook vcs_info
zmodload zsh/datetime

setopt PROMPT_SUBST TRANSIENT_RPROMPT

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes false
zstyle ':vcs_info:git:*' formats ' %F{magenta}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}%b%f:%F{red}%a%f'

# Command duration, shown only when >= 5s.
typeset -g _prompt_cmd_start _prompt_duration
_prompt_preexec() { _prompt_cmd_start=$EPOCHREALTIME }
_prompt_precmd() {
  local rc=$?
  _prompt_duration=
  if [[ -n $_prompt_cmd_start ]]; then
    local -i elapsed=$(( EPOCHREALTIME - _prompt_cmd_start ))
    unset _prompt_cmd_start
    if (( elapsed >= 5 )); then
      if (( elapsed >= 3600 )); then _prompt_duration=" %F{yellow}$((elapsed/3600))h$((elapsed%3600/60))m%f"
      elif (( elapsed >= 60 )); then _prompt_duration=" %F{yellow}$((elapsed/60))m$((elapsed%60))s%f"
      else _prompt_duration=" %F{yellow}${elapsed}s%f"; fi
    fi
  fi
  vcs_info
  # Terminal title: cwd (and command while running, see preexec below).
  print -Pn '\e]2;%~\a'
  return $rc
}
_prompt_title_preexec() { print -Pn "\e]2;${1[1,40]//[[:cntrl:]]/} — %~\a" }

add-zsh-hook preexec _prompt_preexec
add-zsh-hook preexec _prompt_title_preexec
add-zsh-hook precmd  _prompt_precmd

# Continuation / selection prompts.
PROMPT2='%F{8}...%f '

# Colour scheme: user@host blue, path white, branch magenta, duration yellow;
# the prompt symbol is green on success and red after a failed command.
PROMPT='%B%F{blue}%n@%m%f%b %B%F{white}%3~%f%b${vcs_info_msg_0_}${_prompt_duration} %(?.%F{green}.%F{red})%(!.#.>)%f '
