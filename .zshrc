# # uncomment for timing testing (and one at the bottom too)
# zmodload zsh/zprof

export XDG_CONFIG_HOME=$HOME/.config
export PATH="$HOME/.local/bin:$PATH"

# Catppuccin flavour from cache (before instant prompt — omz custom loads later)
typeset -g _catppuccin_flavour_cache="${XDG_CACHE_HOME:-$HOME/.cache}/catppuccin-flavour"
if [[ -r $_catppuccin_flavour_cache ]]; then
  export P10K_CATPPUCCIN_FLAVOUR=$(<$_catppuccin_flavour_cache)
elif [[ "$(uname)" == Darwin ]]; then
  if defaults read -g AppleInterfaceStyle &>/dev/null 2>&1; then
    export P10K_CATPPUCCIN_FLAVOUR=mocha
  else
    export P10K_CATPPUCCIN_FLAVOUR=latte
  fi
  mkdir -p "${_catppuccin_flavour_cache:h}"
  print -r -- "$P10K_CATPPUCCIN_FLAVOUR" >| "$_catppuccin_flavour_cache"
else
  export P10K_CATPPUCCIN_FLAVOUR=mocha
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Necessary for homebrew to work
if [[ -f /usr/local/bin/brew ]]; then
    # Personal mac specific config
    export PATH=$HOME/.local/xonsh-env/xbin:$PATH
    export OLLAMA_HOST="http://windows-pc:11434"
    eval "$(/usr/local/bin/brew shellenv zsh)"
elif [[ -d /home/linuxbrew/.linuxbrew/ ]]; then
    # Linux config
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
elif [[ -d /opt/homebrew/ ]]; then
    # Work Laptop Config
    export PATH=/Users/jose.valle/Developer/DTEXSERVER/dch-tools/.venv/bin:$PATH
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

# Necessary for fzf
export FZF_BASE=$HOMEBREW_PREFIX/bin/fzf

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Custom scripts/plugins live outside ~/.oh-my-zsh so `omz update` keeps working
export ZSH_CUSTOM="${XDG_CONFIG_HOME}/zsh/custom"

# ==========================================
# VULKAN SDK ENVIRONMENT FOR LLAMA.CPP
# ==========================================
export VULKAN_SDK="$HOME/VulkanSDK/1.4.350.1/macOS"
export VK_ICD_FILENAMES="$VULKAN_SDK/share/vulkan/icd.d/MoltenVK_icd.json"
export VK_LAYER_PATH="$VULKAN_SDK/share/vulkan/explicit_layer.d"
# Use an explicit check on DYLD to prevent system profile warnings
if [[ -z "$DYLD_LIBRARY_PATH" ]]; then
    export DYLD_LIBRARY_PATH="$VULKAN_SDK/lib"
else
    export DYLD_LIBRARY_PATH="$VULKAN_SDK/lib:$DYLD_LIBRARY_PATH"
fi

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

# Catppuccin p10k — flavour cached above; refresh zstyle before p10k loads
zstyle ':catppuccin:p10k' theme rainbow
zstyle ':catppuccin:p10k' flavour ${P10K_CATPPUCCIN_FLAVOUR:-mocha}

# Keep this at the end of the file
source $HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme

if [[ "$(uname)" == Linux ]]; then
  [[ ! -f ~/.p10k.remote.zsh ]] || source ~/.p10k.remote.zsh
else
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

catppuccin_p10k_enable_sync
# # uncomment for timing testing (and one at the top too)
# zprof
