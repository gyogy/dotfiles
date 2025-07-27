#!/bin/bash
set -e

echo "[-] Tearing down dotfiles and Neovim setup..."

DF_DIR="$HOME/dotfiles"
TARGETS=(
    ".bashrc"
    ".bash_aliases"
    ".bash_envvars"
    ".bash_functions"
    ".vimrc"
    ".config/nvim"
)

for file in "${TARGETS[@]}"; do
    full="$HOME/$file"
    backup="$HOME/${file}_backup"
    if [ -L "$full" ]; then
        echo "[-] Removing symlink: $full"
        rm "$full"
    fi
    if [ -e "$backup" ]; then
        echo "[+] Restoring backup: ${file}_backup → $file"
        mv "$backup" "$full"
    fi
done

# Remove Neovim installed from GitHub
if [ -d "/opt/nvim-linux64" ]; then
    echo "[-] Removing Neovim installed from GitHub..."
    sudo rm -rf /opt/nvim-linux64
    if [ -L "/usr/local/bin/nvim" ] && [ "$(readlink -f /usr/local/bin/nvim)" = "/opt/nvim-linux64/bin/nvim" ]; then
        echo "[-] Removing symlink /usr/local/bin/nvim"
        sudo rm /usr/local/bin/nvim
    fi
fi

echo "[✓] Teardown complete."

