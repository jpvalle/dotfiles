# Tmux copy markers (mirrors Ghostty OSC 133 C/D semantics).
#
# OSC 133 is not stored in tmux scrollback, so prompts are wrapped with
# zero-width sentinels in p10k. bin/tmux-strip-prompts removes those on copy.
#
# Hook setup is deferred to the first precmd so p10k instant prompt is not
# disturbed during ~/.zshrc sourcing.

if [[ ! -o interactive ]]; then
  return 0
fi

typeset -g _JOSE_COPY_CS=$'\u200c\u2060'
typeset -g _JOSE_COPY_CE=$'\u2060\u200c'
typeset -g _JOSE_COPY_ACTIVE=0

_jose_parent_is_nvim() {
  local pid=$PPID comm
  for _ in 1 2 3 4; do
    comm=$(ps -o comm= -p $pid 2>/dev/null) || return 1
    [[ ${comm:l} == *nvim* ]] && return 0
    pid=$(ps -o ppid= -p $pid 2>/dev/null | tr -d ' ') || return 1
    (( pid > 1 )) || return 1
  done
  return 1
}

# Markers are tmux-only: Ghostty uses OSC 133; Neovim's terminal shows ZW* chars literally.
jose_tmux_copy_markers_enabled() {
  [[ -n ${TMUX:-} && -z ${JOSE_NVIM_TERM:-} && ! _jose_parent_is_nvim ]]
}

jose_p10k_apply_copy_markers() {
  if jose_tmux_copy_markers_enabled; then
    # PS+PE on the time segment — only markers that survive tmux scrollback.
    typeset -g POWERLEVEL9K_TIME_PREFIX=$'\u200b\u2060''at '
    typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'$'\u2060\u200b'
  else
    typeset -g POWERLEVEL9K_TIME_PREFIX='at '
    typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  fi
}

_jose_tmux_copy_preexec() {
  _JOSE_COPY_ACTIVE=1
  builtin print -rn -- "$_JOSE_COPY_CS"
}

_jose_tmux_copy_precmd_ce() {
  (( _JOSE_COPY_ACTIVE )) || return 0
  builtin print -rn -- "$_JOSE_COPY_CE"
  _JOSE_COPY_ACTIVE=0
}

_jose_tmux_copy_setup() {
  add-zsh-hook -d precmd _jose_tmux_copy_setup

  jose_p10k_apply_copy_markers

  if jose_tmux_copy_markers_enabled; then
    add-zsh-hook preexec _jose_tmux_copy_preexec

    if (( $+functions[_p9k_precmd] )); then
      local -i _p9k_idx=${precmd_functions[(I)_p9k_precmd]}
      if (( _p9k_idx )); then
        precmd_functions=(${precmd_functions[1,_p9k_idx-1]} \
          _jose_tmux_copy_precmd_ce \
          ${precmd_functions[_p9k_idx,-1]})
      else
        add-zsh-hook precmd _jose_tmux_copy_precmd_ce
      fi
    else
      precmd_functions=(_jose_tmux_copy_precmd_ce ${precmd_functions:#_jose_tmux_copy_precmd_ce})
    fi
  fi

  # Ghostty OSC 133 — direct shells only (auto-inject skips tmux; manual breaks p10k zle).
  if [[ -z ${TMUX:-} && -n ${GHOSTTY_RESOURCES_DIR:-} ]] \
      && [[ -r "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration" ]]; then
    source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
  fi

  whence zle &>/dev/null && zle -R
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _jose_tmux_copy_setup
