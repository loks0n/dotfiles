# Brewfile
echo ">>> Install brew packages"
env NONINTERACTIVE=1 brew bundle install

# Bare repository settings
echo ">>> Configuring bare repo untracked settings..."
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config status.showUntrackedFiles no
config remote set-url origin git@github.com:loks0n/dotfiles.git

# Setup SSH
set keyfile "$HOME/.ssh/id_ed25519"
if not test -f $keyfile
    echo ">>> Generating new ed25519 keypair"
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh

    ssh-keygen -t ed25519 -a 100 -C "$USER@$(hostname)" -f $keyfile -N ""

    echo ">>> Adding private key to macOS keychain"
    ssh-add --apple-use-keychain $keyfile

    echo ">>> Your new SSH public key:"
    cat "$keyfile.pub"
else
    echo ">>> SSH key already exists, skipping"
end
