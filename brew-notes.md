The standard Homebrew way to do this is brew bundle, which writes a Brewfile — a plain text manifest you can commit to dotfiles and refresh whenever you install
something new.

Recommended: Brewfile

Export your current setup:

brew bundle dump --file=~/dotfiles/Brewfile --describe

That produces a file like:

tap "hashicorp/tap"
brew "neovim"      # Ambitious Vim-fork focused on extensibility
brew "fzf"         # Command-line fuzzy finder written in Go
cask "ghostty"     # Terminal emulator...

It captures:
• Taps (third-party repos)
• Formulae (CLI tools)
• Casks (macOS apps)
• npm / uv packages (if installed via Homebrew’s bundle integration — yours includes some)

Refresh after installing something:

brew bundle dump --force --file=~/dotfiles/Brewfile --describe

--force overwrites the existing file. --describe adds one-line comments, which makes the list useful as documentation even if you never auto-install.

You already have Homebrew wired up in .zshrc for macOS and Linux; a top-level Brewfile in the repo fits that setup well.

────────────────────────────────────────

Alternative lists (simpler, less complete)

┌───────────────────────────────────────────┬────────────────────────────────────┐
│ Goal                                      │ Command                            │
├───────────────────────────────────────────┼────────────────────────────────────┤
│ Only what you installed (no dependencies) │ brew leaves > packages.txt         │
├───────────────────────────────────────────┼────────────────────────────────────┤
│ All formulae                              │ brew list --formula > formulae.txt │
├───────────────────────────────────────────┼────────────────────────────────────┤
│ All casks (macOS only)                    │ brew list --cask > casks.txt       │
└───────────────────────────────────────────┴────────────────────────────────────┘

brew leaves is shorter (~50 packages vs ~200 formulae on your machine) because it skips dependency-only installs. A Brewfile is usually better for dotfiles because
it includes taps and casks too.

────────────────────────────────────────

Cross-platform notes

┌──────────┬───────────┬───────────────────────────────────────────────────────────────────┐
│ Platform │ Homebrew? │ Notes                                                             │
├──────────┼───────────┼───────────────────────────────────────────────────────────────────┤
│ macOS    │ Yes       │ Full support: formulae + casks                                    │
├──────────┼───────────┼───────────────────────────────────────────────────────────────────┤
│ Linux    │ Yes       │ Formulae + taps; no casks                                         │
├──────────┼───────────┼───────────────────────────────────────────────────────────────────┤
│ Windows  │ WSL only  │ Native Windows uses winget, scoop, or chocolatey — separate lists │
└──────────┴───────────┴───────────────────────────────────────────────────────────────────┘

On Linux, brew bundle install (if you ever use it) will skip casks. Keeping one Brewfile is fine: casks are ignored on Linux.

For native Windows, maintain something like windows-packages.txt from winget export or a Scoop bucket list — separate from Homebrew.

────────────────────────────────────────

Easy “update my list” workflow

Add a shell alias or small script in your dotfiles:

# in ~/.zshrc or a dotfiles script
brewsync() {
  brew bundle dump --force --describe --file="$HOME/dotfiles/Brewfile"
  echo "Updated Brewfile ($(grep -cE '^(brew|cask|tap)' "$HOME/dotfiles/Brewfile") entries)"
}

After brew install foo, run brewsync and commit the changed Brewfile.

────────────────────────────────────────

Optional: install later (you said you don’t need this)

If you ever want it:

brew bundle install --file=~/dotfiles/Brewfile

That reads the same file — no separate format.

────────────────────────────────────────

Summary: Run brew bundle dump --file=~/dotfiles/Brewfile --describe, commit it, and re-run with --force whenever you install packages. That replaces the
hand-maintained list in your README (brew install gcc powerlevel10k ...) with something that stays in sync automatically.

Want me to generate the Brewfile in your repo and add a brewsync alias to .zshrc?


