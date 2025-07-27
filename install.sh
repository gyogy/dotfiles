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

get_apt_nvim_version() {
    apt-cache policy neovim | grep Candidate | awk '{print $2}' | cut -d'-' -f1
}

install_nvim_from_github() {
    echo "[+] Installing Neovim from GitHub..."
    sudo apt install -y curl tar gzip jq
    tmp_dir=$(mktemp -d)
    cd "$tmp_dir"

    LATEST_URL=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | \
        jq -r '.assets[] | select(.browser_download_url | test("nvim-linux-x86_64.tar.gz$")) | .browser_download_url')

    if [[ -z "$LATEST_URL" ]]; then
        echo "[!] Failed to get latest Neovim release URL."
        exit 1
    fi

    curl -LO "$LATEST_URL"
    tar xzf nvim-linux-x86_64.tar.gz
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
        return
    fi

    echo "[!] Neovim too old or not installed. Checking apt..."
    sudo apt update

    APT_VER=$(get_apt_nvim_version)
    echo "[-] Available in apt: $APT_VER"

    if version_ge "$APT_VER" "$NVIM_MIN_VERSION"; then
        echo "[+] Installing Neovim via apt..."
        sudo apt install -y neovim
    else
        echo "[!] Apt version too old. Installing from GitHub..."
        install_nvim_from_github
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
git push --set-upstream origin master || true

echo "[+] Bootstrapping Neovim plugins..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerInstall | PackerSync'

source ~/.bashrc
echo "[+] Done."
