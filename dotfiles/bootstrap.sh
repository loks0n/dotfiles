#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    echo "Finish installing Xcode command-line tools, then run this script again." >&2
    exit 1
fi

brew_bin=/opt/homebrew/bin/brew
[[ $(uname -m) == arm64 ]] || brew_bin=/usr/local/bin/brew
if [[ ! -x $brew_bin ]]; then
    installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    /bin/bash -c "$installer"
fi
brew_env="$("$brew_bin" shellenv)"
eval "$brew_env"

export PATH="$HOME/.cargo/bin:$PATH"
if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
rustup toolchain install stable
RUSTUP_TOOLCHAIN=stable brew bundle install --file="$PWD/Brewfile"

git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config status.showUntrackedFiles no

fish_bin="$(command -v fish)"
if ! grep -Fxq "$fish_bin" /etc/shells; then
    printf '%s\n' "$fish_bin" | sudo tee -a /etc/shells >/dev/null
fi
if [[ $SHELL != "$fish_bin" ]]; then
    sudo chsh -s "$fish_bin" "$USER"
fi

echo "Setup complete. Open a new terminal, then run gh auth login and gh auth setup-git."
