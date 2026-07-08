- Need to install `stow`, [article about it](https://www.josean.com/posts/how-to-manage-dotfiles-with-gnu-stow).
- After clone: `git submodule update --init --recursive` (catppuccin-powerlevel10k-themes for p10k)
- Run `git config --local user.email "ID+username@users.noreply.github.com"` to push commits
- Install homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Install with brew: `brew install gcc powerlevel10k zoxide eza fzf neovim lazygit`  
- Install oh-my-zsh `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- Autosuggestions: `git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.config/zsh/custom/plugins/zsh-autosuggestions`
- Syntax Highlighting: `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.config/zsh/custom/plugins/zsh-syntax-highlighting`

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
