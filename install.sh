#!/bin/bash

set -e

DF_DIR="$HOME/dotfiles"
NVIM_MIN_VERSION="0.10.0"
NVIM_BIN="/usr/bin/nvim"

get_nvim_version() {
    if command -v nvim &> /dev/null; then
        nvim --version | head -n1 | awk '{print $2}' | sed 's/^v//'
    else
        echo "0.0.0"
    fi
}

version_ge() {
    dpkg --compare-versions "$1" ge "$2"
}

install_nvim_from_github() {
    echo "[+] Installing Neovim from GitHub..."

    sudo apt install -y curl tar gzip jq

    tmp_dir=$(mktemp -d)
    cd "$tmp_dir"

    echo "[+] Fetching latest release URL from GitHub..."
    LATEST_URL=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | \
        jq -r '.assets[] | select(.browser_download_url | test("nvim-linux-x86_64.tar.gz$")) | .browser_download_url')

    if [[ -z "$LATEST_URL" ]]; then
        echo "[!] Failed to get latest Neovim release URL."
        exit 1
    fi

    echo "[+] Downloading Neovim from: $LATEST_URL"
    curl -LO "$LATEST_URL"

    echo "[+] Extracting archive..."
    tar xzf nvim-linux-x86_64.tar.gz

    echo "[+] Installing to /opt and linking to /usr/bin..."
    sudo mv nvim-linux-x86_64 /opt/
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/bin/nvim

    cd ~
    rm -rf "$tmp_dir"
}

check_nvim_install() {
    CURRENT_VER=$(get_nvim_version)
    echo "[-] Found Neovim version: $CURRENT_VER"

    if version_ge "$CURRENT_VER" "$NVIM_MIN_VERSION"; then
        echo "[+] Neovim meets minimum version requirement."
    else
        echo "[!] Neovim too old or not installed. Checking apt..."
        sudo apt update
        sudo apt install -y neovim || true

        CURRENT_VER=$(get_nvim_version)
        if version_ge "$CURRENT_VER" "$NVIM_MIN_VERSION"; then
            echo "[+] Successfully updated Neovim via apt."
        else
            echo "[!] Apt version too old or missing. Installing from GitHub..."
            install_nvim_from_github
        fi
    fi
}

backup_symlinks_if_needed() {
    local target="$1"
    local full="$HOME/$target"
    local backup="${full}.backup"
    if [ -e "$full" ] && [ ! -L "$full" ]; then
        echo "[-] Backing up $target → ${target}.backup"
        mv "$full" "$backup"
    fi
}

echo "[+] Checking Neovim version..."
check_nvim_install

echo "[+] Backing up and symlinking config files..."
TARGETS=(
    ".bashrc"
    ".bash_aliases"
    ".bash_envvars"
    ".bash_functions"
    ".vimrc"
)

for file in "${TARGETS[@]}"; do
    backup_symlinks_if_needed "$file"
    ln -sf "$DF_DIR/$file" "$HOME/$file"
done

mkdir -p ~/.config
backup_symlinks_if_needed ".config/nvim"
ln -sf "$DF_DIR/.config/nvim" ~/.config/nvim

echo "[+] Setting up SSH remote for git..."
cd "$DF_DIR"
git remote remove origin 2>/dev/null || true
git remote add origin git@github.com:gyogy/dotfiles.git

echo "[+] Bootstrapping Neovim plugins..."
nvim --headless +"autocmd User PackerComplete quitall" +PackerSync

source ~/.bashrc
echo "[+] Done."
