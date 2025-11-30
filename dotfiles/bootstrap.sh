#!/usr/bin/env bash
set -euo pipefail

need_sudo() {
    if [[ $EUID -ne 0 ]]; then
        sudo true
    fi
}

# Xcode
echo ">>> Ensuring Xcode command-line tools installed..."
xcode-select -p >/dev/null 2>&1 || xcode-select --install >/dev/null 2>&1 || true

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
    echo ">>> Installing Homebrew..."
    NONINTERACTIVE=1 \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -d /opt/homebrew/bin ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d /usr/local/bin ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Fish
echo ">>> Installing fish via Homebrew..."
brew install fish >/dev/null 2>&1 || true

echo ">>> Ensuring fish is in /etc/shells..."
need_sudo
if ! grep -q "$(command -v fish)" /etc/shells; then
    echo "$(command -v fish)" | sudo tee -a /etc/shells >/dev/null
fi

echo ">>> Setting fish as default shell..."
need_sudo
sudo chsh -s "$(command -v fish)" "$USER"

# Setup
echo ">>> Bootstrap complete. Launching setup..."
fish ./setup.fish
