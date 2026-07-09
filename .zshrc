# # uncomment for timing testing (and one at the bottom too)
# zmodload zsh/zprof

export XDG_CONFIG_HOME=$HOME/.config
export PATH="$HOME/.local/bin:$XDG_CONFIG_HOME/theme/bin:$PATH"

# Central theme manifest: ~/.config/theme/manifest.toml
if [[ -x "${XDG_CONFIG_HOME}/theme/bin/theme-sync" ]]; then
  "${XDG_CONFIG_HOME}/theme/bin/theme-sync" --quiet 2>/dev/null || true
fi
if [[ -r "${XDG_STATE_HOME:-$HOME/.local/state}/theme/current.env" ]]; then
  source "${XDG_STATE_HOME:-$HOME/.local/state}/theme/current.env"
fi
export P10K_CATPPUCCIN_FLAVOUR="${THEME_P10K:-mocha}"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew (macOS only): Apple Silicon (/opt/homebrew) or Intel (/usr/local)
if [[ "$(uname)" == Darwin ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv zsh)"
  fi
fi

# fzf (oh-my-zsh plugin): Homebrew on macOS, distro packages on Linux
if [[ -n "${HOMEBREW_PREFIX:-}" && -d "${HOMEBREW_PREFIX}/opt/fzf" ]]; then
  export FZF_BASE="${HOMEBREW_PREFIX}/opt/fzf"
elif [[ -d /usr/share/fzf ]]; then
  export FZF_BASE=/usr/share/fzf
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Custom scripts/plugins live outside ~/.oh-my-zsh so `omz update` keeps working
export ZSH_CUSTOM="${XDG_CONFIG_HOME}/zsh/custom"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM is set above (~/.config/zsh/custom via stow)

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git web-search fzf zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Environment variables
export EDITOR=nvim
export PAGER=less
export GIT_EDITOR=nvim

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ---- Eza (better ls) -----

alias ls="eza --icons=always"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

# p10k flavour from central theme manifest (Catppuccin families only)
if [[ "${THEME_P10K_STYLE:-catppuccin}" == "catppuccin" ]]; then
  zstyle ':catppuccin:p10k' theme rainbow
  zstyle ':catppuccin:p10k' flavour ${THEME_P10K:-mocha}
fi

# Powerlevel10k: Homebrew on macOS, distro or local install on Linux
typeset -g _P10K_THEME_FILE=
if [[ -n "${HOMEBREW_PREFIX:-}" && -r "${HOMEBREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  _P10K_THEME_FILE="${HOMEBREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme"
elif [[ -r /usr/share/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  _P10K_THEME_FILE=/usr/share/powerlevel10k/powerlevel10k.zsh-theme
elif [[ -r "${XDG_DATA_HOME:-$HOME/.local/share}/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  _P10K_THEME_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/powerlevel10k/powerlevel10k.zsh-theme"
fi
[[ -n $_P10K_THEME_FILE ]] && source "$_P10K_THEME_FILE"
unset _P10K_THEME_FILE

# p10k config: same Catppuccin setup on macOS and Linux; work machines may use ~/.p10k.work.zsh locally
if [[ -r ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
fi

theme_p10k_enable_sync
# # uncomment for timing testing (and one at the top too)
# zprof
