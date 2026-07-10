# Theme sync — manifest: ~/.config/theme/manifest.toml
# Flavour resolved by theme-sync into ~/.local/state/theme/current.env

typeset -g _THEME_SYNC_LAST=0

theme_p10k_refresh() {
  [[ "${THEME_P10K_STYLE:-catppuccin}" != "catppuccin" ]] && return 0

  local _flavour=${1:-${THEME_P10K:-${P10K_CATPPUCCIN_FLAVOUR:-mocha}}}

  export P10K_CATPPUCCIN_FLAVOUR=$_flavour
  export THEME_P10K=$_flavour
  zstyle ':catppuccin:p10k' theme rainbow
  zstyle ':catppuccin:p10k' flavour $_flavour

  local _p10k=${ZDOTDIR:-$HOME}/.p10k.zsh
  [[ -f $_p10k ]] && source "$_p10k"
  whence jose_p10k_apply_copy_markers &>/dev/null && jose_p10k_apply_copy_markers

  whence zle &>/dev/null && zle -R
}

theme_p10k_sync() {
  [[ "${THEME_P10K_STYLE:-catppuccin}" != "catppuccin" ]] && return 0

  local _flavour=${THEME_P10K:-${P10K_CATPPUCCIN_FLAVOUR:-mocha}}
  [[ "${P10K_CATPPUCCIN_FLAVOUR:-}" == "$_flavour" ]] && return 0
  theme_p10k_refresh "$_flavour"
}

_p10k_theme_precmd() {
  (( EPOCHSECONDS - _THEME_SYNC_LAST < 2 )) && return
  _THEME_SYNC_LAST=$EPOCHSECONDS

  local _before=${THEME_APPEARANCE:-}
  theme-sync --quiet 2>/dev/null || return
  [[ -r "${XDG_STATE_HOME:-$HOME/.local/state}/theme/current.env" ]] && \
    source "${XDG_STATE_HOME:-$HOME/.local/state}/theme/current.env"

  if [[ "$_before" != "${THEME_APPEARANCE:-}" ]]; then
    theme_p10k_refresh "${THEME_P10K:-mocha}"
  else
    theme_p10k_sync
  fi
}

theme_p10k_enable_sync() {
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _p10k_theme_precmd
}

p10k-sync-theme() {
  theme-sync
  [[ -r "${XDG_STATE_HOME:-$HOME/.local/state}/theme/current.env" ]] && \
    source "${XDG_STATE_HOME:-$HOME/.local/state}/theme/current.env"
  theme_p10k_refresh "${THEME_P10K:-mocha}"
  print -r "p10k synced to ${THEME_FAMILY:-theme}-${THEME_P10K:-unknown}"
}

# Backward-compatible aliases
catppuccin_p10k_refresh() { theme_p10k_refresh "$@" }
catppuccin_p10k_sync() { theme_p10k_sync "$@" }
catppuccin_p10k_enable_sync() { theme_p10k_enable_sync }
