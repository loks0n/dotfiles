# Laptop setup

## New Mac

Install Apple's command-line tools first, and wait for the installer to finish:

```sh
xcode-select --install
```

Restore the dotfiles (the repository is public, so this needs no GitHub login):

```sh
git clone --bare https://github.com/loks0n/dotfiles.git "$HOME/.dotfiles"
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config status.showUntrackedFiles no
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
bash "$HOME/dotfiles/bootstrap.sh"
```

If checkout reports existing files, move those files aside and retry; don't force
checkout over settings you want to keep. The bootstrap can be run from any directory
and rerun after a failed install. It installs Homebrew, stable Rust via rustup, the
Brewfile (including Go, Cargo and npm tools), and sets Fish as the login shell.
Allow macOS password prompts and any application installers to finish.

Open a new terminal, then authenticate:

```sh
gh auth login
gh auth setup-git
```

HTTPS works for pushing too. To use SSH instead, create or securely transfer a key,
register it with GitHub, and then run:

```fish
config remote set-url origin git@github.com:loks0n/dotfiles.git
```

## Finish the migration

- Sign into Bitwarden and desktop apps. Install other apps you still use that
  aren't in the Brewfile, such as ChatGPT, Claude Desktop and hardware utilities.
- Install Claude Code with its [native installer](https://code.claude.com/docs/en/setup):
  `curl -fsSL https://claude.ai/install.sh | bash`.
- Sign into cloud CLIs and recreate Kubernetes contexts. Securely transfer any
  SSH configuration, keys and credentials that cannot be recreated.
- Restore personal agent instructions/settings and custom skills selectively;
  review them for embedded credentials and old absolute paths first.
- Copy local projects and any required OrbStack volumes. Review custom
  `~/Library/LaunchAgents/systems.bothy.fency-*.plist` jobs and their script paths
  separately before enabling them on the new laptop.
- Install additional Rust toolchains required by individual projects. Bootstrap
  installs stable rather than copying this machine's historical toolchains.

## Keep it current

In Fish, `config` is Git with `~/.dotfiles` as its repository and `~` as its worktree:

```fish
config status
config diff
config add <specific-files>
config commit -m "chore: sync dotfiles"
config push origin main
```

New files are hidden from status. Add selected config files explicitly; never add
all of your home directory. Keep credentials, histories, caches and machine state
out of this repository.

To refresh the install inventory, inspect a snapshot before editing the Brewfile:

```sh
brew bundle dump --file=-
```

[Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile) records tools from
multiple package managers. Keep one installation per tool (Task, yq and ytt are
managed through Homebrew here). Bun and uv are also managed through Homebrew on
new laptops, so separate installers aren't needed. The Brewfile is an install
inventory, not a version lockfile. Do not run `brew bundle cleanup` as part of setup.
