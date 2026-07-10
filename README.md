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

Package manifests live in `brew/` (macOS) and `packages/` (Linux). Both support a shared base list plus an optional, gitignored work overlay.

### macOS (Homebrew)

Homebrew location is detected automatically: `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel).

```bash
/path/to/dotfiles/bin/brew-bundle-install
```

That reads `brew/Brewfile.base` and, if present, layers `brew/Brewfile.work` on top. Work machines can keep a local work file without committing it:

```bash
cp brew/Brewfile.work.example brew/Brewfile.work   # first time on a work Mac
```

Key packages: `stow`, `powerlevel10k`, `zoxide`, `eza`, `fzf`, `neovim`, `lazygit`, `git-delta`, `tmux`.

#### Brewfile layout

| File | Tracked | Contents |
|------|---------|----------|
| `brew/Brewfile.base` | yes | Shared formulae, casks, taps, npm/uv tools |
| `brew/Brewfile.work` | no (gitignored) | Work-only: Cursor/Copilot CLI, Atlassian MCP, etc. |
| `brew/Brewfile.work.example` | yes | Template to copy for `Brewfile.work` |

#### Sync after installing something

```bash
# refresh base (shared) list
brew bundle dump --force --describe --file=~/dotfiles/brew/Brewfile.base

# refresh work list on a work Mac
brew bundle dump --force --describe --file=~/dotfiles/brew/Brewfile.work
```

Only commit `Brewfile.base` (and update `packages/apt.txt` / `packages/dnf.txt` when Linux equivalents change).

#### Undo / remove a package

`brew bundle` has no undo. Remove in two steps:

1. **Uninstall from the machine** (examples):

   ```bash
   brew uninstall foo                  # brew "foo"
   brew uninstall --cask foo           # cask "foo"
   uv tool uninstall thing             # uv "thing"
   npm uninstall -g foo                # npm "foo"
   ```

2. **Remove from the Brewfile** so it is not reinstalled:

   ```bash
   brew bundle remove --uv thing --file=~/dotfiles/brew/Brewfile.work
   ```

   Or delete the line manually.

`brew bundle cleanup --file=...` uninstalls things that are installed but **not** listed in the Brewfile. Use with care — it can remove manually installed packages too. Scope it when needed:

```bash
brew bundle cleanup --file=- --uv          # dry run (uv tools only)
brew bundle cleanup --force --file=- --uv  # actually remove
```

Pipe layered files the same way as install: `cat brew/Brewfile.base brew/Brewfile.work | brew bundle cleanup --file=-`.

### Linux (apt, dnf)

No Homebrew on Linux — use plain package lists instead:

| File | Tracked | Contents |
|------|---------|----------|
| `packages/apt.txt` | yes | Debian/Ubuntu packages matching `Brewfile.base` |
| `packages/dnf.txt` | yes | Fedora/RHEL packages matching `Brewfile.base` |
| `packages/work.apt.txt` | no (gitignored) | Work-only apt packages |
| `packages/work.dnf.txt` | no (gitignored) | Work-only dnf packages |

```bash
/path/to/dotfiles/bin/packages-install
```

Detects `apt-get` or `dnf`, installs the base list, then layers the matching work file if it exists. First time on a work machine:

```bash
cp packages/work.apt.txt.example packages/work.apt.txt   # Debian/Ubuntu
cp packages/work.dnf.txt.example packages/work.dnf.txt   # Fedora
```

Package names differ between distros and from Homebrew (e.g. `fd` → `fd-find` on apt). Some macOS-only Brewfile entries (casks, `skhd`, `yabai`, `colima`) have no Linux package — install via upstream, `cargo`, `pipx`, or `npm` instead. Notable examples:

| Tool | Typical Linux install |
|------|----------------------|
| `eza`, `zoxide`, `starship`, `lazygit` | `cargo install …` or distro COPR/third-party repo |
| `ollama` | upstream install script or distro package when available |

Zsh plugins come from git submodules in this repo — no extra install step.

#### Linux shell setup (required for the prompt)

`packages-install` does **not** install Powerlevel10k. On macOS it comes from Homebrew; on Linux you must install it separately or the prompt falls back to zsh’s default (`hostname%` with no colours, icons, or git segment).

After stow, submodules, Oh My Zsh, and `packages-install`, install Powerlevel10k where `~/.zshrc` expects it:

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${XDG_DATA_HOME:-$HOME/.local/share}/powerlevel10k"
exec zsh
```

Some distros package it (install path may differ from the above):

```bash
sudo apt install zsh-theme-powerlevel10k    # Debian/Ubuntu, if available
sudo dnf install powerlevel10k              # Fedora
```

If the distro package installs elsewhere, prefer the git clone — it matches the path your `.zshrc` checks.

Also install a **Nerd Font** in your terminal (e.g. SauceCodePro Nerd Font). Without it, p10k loads but separators and icons may show as boxes.

**Typical Linux order** (run from inside the dotfiles repo):

```bash
cd ~/dotfiles
git submodule update --init --recursive
stow -v -R -t "$HOME" .
./bin/packages-install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${XDG_DATA_HOME:-$HOME/.local/share}/powerlevel10k"
exec zsh
```

If Oh My Zsh is already installed, skip the installer — re-running it warns that `~/.oh-my-zsh` exists; that is fine.

**Quick prompt diagnostics** if something looks wrong:

```bash
test -f ~/.oh-my-zsh/oh-my-zsh.sh && echo omz_ok || echo omz_MISSING
test -f ~/.config/zsh/custom/plugins/catppuccin-powerlevel10k-themes/catppuccin-powerlevel10k-themes.plugin.zsh \
  && echo catppuccin_ok || echo catppuccin_MISSING
test -f ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme && echo p10k_ok || echo p10k_MISSING
zsh -lic 'whence p10k &>/dev/null && echo p10k_loaded || echo p10k_not_loaded'
```

| Symptom | Likely cause |
|---------|----------------|
| `hostname%` only | Powerlevel10k not installed (`p10k_MISSING`) |
| `p10k: missing catppuccin-powerlevel10k-themes` | Submodules not initialized — run `git submodule update --init --recursive` from `~/dotfiles` |
| Boxes/question marks in prompt | Nerd Font not set in terminal |

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
| `.config/zsh/custom/work-env.zsh` | Work PATH (venv, etc.) |
| `.config/zsh/custom/aliases-work.zsh` | Work directory shortcuts |
| `brew/Brewfile.work` | Work-only Homebrew manifest (see `brew/Brewfile.work.example`) |
| `packages/work.apt.txt`, `packages/work.dnf.txt` | Work-only Linux package lists |
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
