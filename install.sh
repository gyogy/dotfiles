#!/bin/bash

backup_if_needed() {
    local target="$1"
    if [ -e "$HOME/$target" ] && [ ! -L "$HOME/$target" ]; then
        echo "[-] Backing up existing $target to ${target}_backup"
        mv "$HOME/$target" "$HOME/${target}_backup"
    fi
}

# Exit on any error
set -e

echo "[+] Installing dotfiles..."

DF_DIR="$HOME/dotfiles"
TARGETS=(
    ".bashrc"
    ".bash_aliases"
    ".bash_envvars"
    ".bash_functions"
    ".vimrc"
)

# Symlink dotfiles
for file in "${TARGETS[@]}"; do
    backup_if_needed "$file"
    ln -sf "$DF_DIR/$file" "$HOME/$file"
done

# Neovim config
mkdir -p ~/.config
backup_if_needed ".config/nvim"
ln -sf "$DF_DIR/.config/nvim" ~/.config/nvim

echo "[+] Installing required packages: git, neovim"
sudo apt update
sudo apt install -y git neovim

echo "[+] Bootstrapping Neovim plugins via Packer..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

source ~/.bashrc

echo "[✓] Done!"

