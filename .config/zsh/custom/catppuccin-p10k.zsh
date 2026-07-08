# Catppuccin Powerlevel10k — flavour cache + throttled OS sync
# Plugin: catppuccin-powerlevel10k-themes (zstyle + apply_catppuccin)
# Tmux OS sync: ivuorinen/tmux-dark-notify + dark-notify (brew)

typeset -g _CATPPUCCIN_FLAVOUR_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/catppuccin-flavour"
typeset -g _P10K_APPEARANCE_LAST_CHECK=0

catppuccin_p10k_flavour() {
  local _flavour

  if [[ -r $_CATPPUCCIN_FLAVOUR_CACHE ]]; then
    _flavour=$(<$_CATPPUCCIN_FLAVOUR_CACHE)
    if [[ $_flavour == (mocha|latte|frappe|macchiato) ]]; then
      print -r -- $_flavour
      return 0
    fi
  fi

  if [[ "$(uname)" != Darwin ]]; then
    _flavour=mocha
  elif defaults read -g AppleInterfaceStyle &>/dev/null 2>&1; then
    _flavour=mocha
  else
    _flavour=latte
  fi

  mkdir -p "${_CATPPUCCIN_FLAVOUR_CACHE:h}"
  print -r -- $_flavour >| "$_CATPPUCCIN_FLAVOUR_CACHE"
  print -r -- $_flavour
}

catppuccin_p10k_refresh() {
  local _flavour=${1:-$(catppuccin_p10k_flavour)}

  export P10K_CATPPUCCIN_FLAVOUR=$_flavour
  print -r -- $_flavour >| "$_CATPPUCCIN_FLAVOUR_CACHE"
  zstyle ':catppuccin:p10k' theme rainbow
  zstyle ':catppuccin:p10k' flavour $_flavour

  local _p10k=${ZDOTDIR:-$HOME}/.p10k.zsh
  [[ -f $_p10k ]] && source "$_p10k"

  whence zle &>/dev/null && zle -R
}

catppuccin_p10k_sync() {
  local _flavour=${1:-$(catppuccin_p10k_flavour)}
  [[ "${P10K_CATPPUCCIN_FLAVOUR:-}" == "$_flavour" ]] && return 0
  catppuccin_p10k_refresh "$_flavour"
}

_p10k_catppuccin_precmd() {
  [[ "$(uname)" != Darwin ]] && return
  (( EPOCHSECONDS - _P10K_APPEARANCE_LAST_CHECK < 2 )) && return
  _P10K_APPEARANCE_LAST_CHECK=$EPOCHSECONDS

  local _cached _flavour
  _cached=$(<$_CATPPUCCIN_FLAVOUR_CACHE 2>/dev/null)

  if defaults read -g AppleInterfaceStyle &>/dev/null 2>&1; then
    _flavour=mocha
  else
    _flavour=latte
  fi

  [[ "$_cached" == "$_flavour" ]] && return
  catppuccin_p10k_sync "$_flavour"
}

catppuccin_p10k_enable_sync() {
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _p10k_catppuccin_precmd
}

p10k-sync-theme() {
  rm -f "$_CATPPUCCIN_FLAVOUR_CACHE"
  catppuccin_p10k_sync "$(catppuccin_p10k_flavour)"
  print -r "p10k synced to catppuccin-${P10K_CATPPUCCIN_FLAVOUR}"
}
