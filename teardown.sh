#!/bin/bash

set -e

DF_DIR="$HOME/dotfiles"
NVIM_LINK="/usr/bin/nvim"
NVIM_DIRS=(
    "/opt/nvim-linux64"
    "/opt/nvim-linux-x86_64"
    "$HOME/.local/share/nvim"
    "$HOME/.local/state/nvim"
    "$HOME/.cache/nvim"
    "$HOME/.config/nvim"
)

echo "[+] Reversing dotfile symlinks and restoring backups..."

TARGETS=(
    ".bashrc"
    ".bash_aliases"
    ".bash_envvars"
    ".bash_functions"
    ".vimrc"
)

for file in "${TARGETS[@]}"; do
    full="$HOME/$file"
    backup="${full}.backup"
    if [ -L "$full" ]; then
        echo "[-] Removing symlink: $full"
        rm "$full"
    fi
    if [ -e "$backup" ]; then
        echo "[+] Restoring backup: $backup → $full"
        mv "$backup" "$full"
    fi
done

# Remove symlinked nvim config
NVIM_CONFIG="$HOME/.config/nvim"
if [ -L "$NVIM_CONFIG" ]; then
    echo "[-] Removing symlink: $NVIM_CONFIG"
    rm "$NVIM_CONFIG"
fi
if [ -d "$NVIM_CONFIG.backup" ]; then
    echo "[+] Restoring config backup: $NVIM_CONFIG.backup → $NVIM_CONFIG"
    mv "$NVIM_CONFIG.backup" "$NVIM_CONFIG"
fi

echo "[+] Uninstalling Neovim and cleaning all related files..."

# Remove /usr/bin/nvim if it's a symlink or binary
if command -v nvim &> /dev/null; then
    echo "[-] Removing Neovim binary from: $(command -v nvim)"
    sudo rm -f "$(command -v nvim)" || true
fi

# Remove any known Neovim install directories
for dir in "${NVIM_DIRS[@]}"; do
    if [ -e "$dir" ]; then
        echo "[-] Deleting $dir"
        sudo rm -rf "$dir"
    fi
done

# Uninstall Neovim via apt if present
if dpkg -l | grep -q '^ii  neovim'; then
    echo "[-] Removing Neovim installed via apt"
    sudo apt remove --purge -y neovim
fi

echo "[+] Deleting dotfiles repo..."
if [ -d "$DF_DIR" ]; then
    rm -rf "$DF_DIR"
fi

echo "[+] Teardown complete."
