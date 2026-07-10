#!/usr/bin/env bash
# Edit from lazygit: reuse parent Neovim when reachable; else run nvim in this terminal.
# Standalone lazygit quits after nvim exits so you are not forced back to lazygit.
# Set LAZYGIT_EDIT_STAY=1 to return to lazygit instead (old behavior).
set -euo pipefail

filename=$1
line=${2:-}

nvim_server() {
  if [[ -n "${NVIM:-}" ]]; then
    printf '%s' "$NVIM"
    return 0
  fi
  if [[ -n "${NVIM_LISTEN_ADDRESS:-}" ]]; then
    printf '%s' "$NVIM_LISTEN_ADDRESS"
    return 0
  fi
  return 1
}

nvim_reachable() {
  local server
  server=$(nvim_server) || return 1

  if [[ "$server" != *:* ]]; then
    [[ -e "$server" ]] || return 1
  fi

  nvim --server "$server" --remote-expr "1" &>/dev/null
}

open_in_parent_nvim() {
  local server state_dir target
  server=$(nvim_server)
  state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/lazygit"
  target="$state_dir/edit.target"
  mkdir -p "$state_dir"

  if [[ -n "$line" ]]; then
    printf '%s\n%s\n' "$filename" "$line" > "$target"
  else
    printf '%s\n' "$filename" > "$target"
  fi

  nvim --server "$server" --remote-send "<Cmd>lua require('jose.core.lazygit-edit').dispatch()<CR>"
}

quit_lazygit() {
  [[ "${LAZYGIT_EDIT_STAY:-}" == 1 ]] && return 0

  local pid=$PPID
  while [[ -n "$pid" && "$pid" -gt 1 ]]; do
    local comm
    comm=$(ps -o comm= -p "$pid" 2>/dev/null || true)
    if [[ "$comm" == *lazygit* ]]; then
      kill -TERM "$pid" 2>/dev/null || true
      return 0
    fi
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
  done
}

if nvim_reachable; then
  open_in_parent_nvim
  exit 0
fi

if [[ -n "$line" ]]; then
  nvim +"$line" -- "$filename"
else
  nvim -- "$filename"
fi

quit_lazygit
