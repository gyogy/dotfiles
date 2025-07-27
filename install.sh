#!/bin/bash

backup_if_needed() {
    local target="$1"
    if [ -e "$HOME/$target" ] && [ ! -L "$HOME/$target" ]; then
        echo "[-] Backing up existing $target to ${target}.backup"
        mv "$HOME/$target" "$HOME/${target}.backup"
    fi
}

set -e # Exit on any error

echo "[+] Installing dotfiles..."

DF_DIR="$HOME/dotfiles"
echo "[+] Dotfiles directory set to $DF_DIR"

TARGETS=(
    ".bashrc"
    ".bash_aliases"
    ".bash_envvars"
    ".bash_functions"
    ".vimrc"
)

# Symlink core dotfiles
for file in "${TARGETS[@]}"; do
    backup_if_needed "$file"
    ln -sf "$DF_DIR/$file" "$HOME/$file"
done

# Neovim config
mkdir -p ~/.config
backup_if_needed ".config/nvim"
ln -sf "$DF_DIR/.config/nvim" ~/.config/nvim

# Set SSH remote if not already using it
cd "$DF_DIR"
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "none")
if [[ "$CURRENT_REMOTE" != git@github.com:* ]]; then
    echo "[+] Setting Git remote to SSH"
    git remote set-url origin git@github.com:gyogy/dotfiles.git
else
    echo "[=] Git remote already using SSH"
fi

# Check if SSH key works with GitHub
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "[✓] SSH authentication with GitHub confirmed"
else
    echo "[!] WARNING: SSH key may not be added to GitHub or agent"
    echo "    Run: ssh -T git@github.com"
    echo "    Or add your key at: https://github.com/settings/ssh/new"
fi

# Install required packages
echo "[+] Installing required packages: git, neovim"
sudo apt update
sudo apt install -y git neovim

# Bootstrap Neovim plugins
echo "[+] Bootstrapping Neovim plugins via Packer..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "[✓] Dotfiles installation complete. Restart shell or run: source ~/.bashrc"

