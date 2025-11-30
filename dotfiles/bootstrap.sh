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

# Bare repository setup
echo ">>> Configuring bare repo untracked settings..."
if [ -d "$HOME/.dotfiles" ]; then
    /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME config status.showUntrackedFiles no
fi

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

echo ">>> Creating fish function directory..."
mkdir -p ~/.config/fish/functions

echo ">>> Installing 'config' function..."
cat > ~/.config/fish/functions/config.fish <<'EOF'
function config
    /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
end
EOF

#8. Configure bare repo untracked behaviour


echo ">>> Bootstrap complete. Launching fish..."
exec fish
