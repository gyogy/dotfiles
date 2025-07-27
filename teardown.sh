#!/bin/bash

# Exit on any error
set -e

echo "[!] Tearing down dotfiles setup..."

DOTFILES_DIR="$HOME/dotfiles"
TARGETS=(
    ".bashrc"
    ".bash_aliases"
    ".bash_envvars"
    ".bash_functions"
    ".vimrc"
)

# Remove symlinks and restore backups if present
for file in "${TARGETS[@]}"; do
    full="$HOME/$file"
    backup="$HOME/${file}_backup"
    
    if [ -L "$full" ]; then
        echo "[-] Removing symlink: $file"
        rm "$full"
    fi

    if [ -e "$backup" ]; then
        echo "[+] Restoring backup: ${file}_backup → $file"
        mv "$backup" "$full"
    fi
done

# Neovim config
NVIM_CONFIG="$HOME/.config/nvim"
if [ -L "$NVIM_CONFIG" ]; then
    echo "[-] Removing symlink: .config/nvim"
    rm "$NVIM_CONFIG"
fi

# Remove Packer + plugin data
if [ -d "$HOME/.local/share/nvim" ]; then
    echo "[-] Removing ~/.local/share/nvim (Packer and plugins)"
    rm -rf "$HOME/.local/share/nvim"
fi

# Optional: remove Neovim
read -p "Remove Neovim? (y/N): " confirm_nvim
if [[ "$confirm_nvim" == "y" || "$confirm_nvim" == "Y" ]]; then
    echo "[-] Removing Neovim via apt..."
    sudo apt remove --purge -y neovim
    sudo apt autoremove -y
fi

# Optional: delete the dotfiles repo itself
read -p "Delete the dotfiles repo at $DOTFILES_DIR? (y/N): " confirm_repo
if [[ "$confirm_repo" == "y" || "$confirm_repo" == "Y" ]]; then
    echo "[-] Deleting $DOTFILES_DIR"
    rm -rf "$DOTFILES_DIR"
fi

echo "[✓] Teardown complete."

