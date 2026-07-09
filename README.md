# Dotfiles bootstrap

Portable setup: clone anywhere, `stow` into `$HOME`, no hardcoded repo paths in config.

## Fresh machine

```bash
git clone --recurse-submodules <your-repo-url> /path/to/dotfiles
cd /path/to/dotfiles
git submodule update --init --recursive   # if cloned without --recurse-submodules
stow -v -R -t "$HOME" --adopt .
./bin/bootstrap                           # optional: same as above + theme-sync + local templates
```

To remove symlinks when leaving a machine:

```bash
cd /path/to/dotfiles
stow -v -D -t "$HOME" .
```

## Dependencies

### macOS (Homebrew)

Homebrew location is detected automatically: `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel).

```bash
brew bundle install --file=/path/to/dotfiles/Brewfile
```

Key packages: `stow`, `powerlevel10k`, `zoxide`, `eza`, `fzf`, `neovim`, `lazygit`, `git-delta`, `tmux`.

### Linux (apt, dnf, etc.)

No Homebrew on Linux — install the same tools with your distro package manager. Package names vary; examples:

```bash
# Debian/Ubuntu
sudo apt install stow zsh fzf neovim tmux git-delta

# Fedora
sudo dnf install stow zsh fzf neovim tmux git-delta
```

Also install via your distro or upstream when not packaged: `zoxide`, `eza`, `lazygit`, `powerlevel10k` (or place powerlevel10k under `~/.local/share/powerlevel10k/`). Zsh plugins come from git submodules in this repo — no extra install step.

## Oh My Zsh

Install once (keeps your stowed `~/.zshrc`):

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
```

## Git submodules

All zsh plugins are submodules — no manual `git clone` needed:

| Submodule | Purpose |
|-----------|---------|
| `catppuccin-powerlevel10k-themes` | Catppuccin p10k colours |
| `zsh-autosuggestions` | Fish-like suggestions |
| `zsh-syntax-highlighting` | Command highlighting |

After `git pull`:

```bash
git submodule update --init --recursive
```

If `git submodule update --init` fails on an old clone, run `git submodule sync --recursive` first.

## Machine-local files (gitignored)

| File | Purpose |
|------|---------|
| `.config/zsh/custom/local-env.zsh` | Personal PATH, Vulkan, Ollama, etc. (see `local-env.zsh.example`) |
| `.config/zsh/custom/work-env.zsh` | Work PATH (DTEX venv, etc.) |
| `.config/zsh/custom/aliases-work.zsh` | Work directory shortcuts |
| `~/.config/git/local` | Git name/email, work `includeIf` (see `local.example`) |
| `.work.zshrc`, `.p10k.work.zsh` | Alternate work shell config (not shared) |

## Theme (single source of truth)

Edit `~/.config/theme/manifest.toml`:

1. Set `family = "..."` to the theme you want (e.g. `catppuccin`, `tokyonight`, `gruvbox`, `nord`, `rose-pine`, `dracula`)
2. Uncomment the matching `[families.NAME]` block and comment out the previous one
3. Run `theme-sync` (also runs from zsh startup, nvim focus, and on OS light/dark changes)

Bundled alternate families (commented templates in the manifest):

| Family | Neovim plugin | Notes |
|--------|---------------|-------|
| `tokyonight` | folke/tokyonight.nvim | Full light/dark |
| `gruvbox` | ellisonleao/gruvbox.nvim | Full light/dark |
| `nord` | arcticicestudio/nord-vim | Light nvim uses Solarized fallback |
| `rose-pine` | rose-pine/neovim | Moon/Dawn variants |
| `dracula` | dracula/vim | Dark-only; light uses Gruvbox fallback |

Catppuccin is the only family that syncs Powerlevel10k catppuccin flavours. Other families keep your existing p10k config as-is.

After changing the manifest: `theme-sync`. Reload tmux with `prefix + r` if needed. Reopen LazyGit to pick up palette changes.

## Git identity

```bash
cp .config/git/local.example ~/.config/git/local   # edit name/email
git config --local user.email "ID+username@users.noreply.github.com"   # commits in this repo
```
