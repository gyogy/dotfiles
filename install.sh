#!/bin/bash
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

backup_if_needed() {
    local target="$1"
    local full="$HOME/$target"
    local backup="$HOME/${target}_backup"
    if [ -e "$full" ] && [ ! -L "$full" ]; then
        echo "[-] Backing up existing $target → ${target}_backup"
        mv "$full" "$backup"
    fi
}

for file in "${TARGETS[@]}"; do
    backup_if_needed "$file"
    ln -sf "$DF_DIR/$file" "$HOME/$file"
done

# Neovim config
mkdir -p "$HOME/.config"
backup_if_needed ".config/nvim"
ln -sf "$DF_DIR/.config/nvim" "$HOME/.config/nvim"

echo "[+] Ensuring git and curl are installed..."
sudo apt update
sudo apt install -y git curl unzip

# Check for Neovim ≥ 0.10
INSTALL_NVIM=false
if command -v nvim &>/dev/null; then
    NVIM_VER=$(nvim --version | head -n1 | awk '{print $2}')
    MAJOR=$(echo "$NVIM_VER" | cut -d. -f1)
    MINOR=$(echo "$NVIM_VER" | cut -d. -f2)
    if [ "$MAJOR" -eq 0 ] && [ "$MINOR" -lt 10 ]; then
        echo "[-] Neovim version $NVIM_VER too old"
        INSTALL_NVIM=true
    fi
else
    echo "[-] Neovim not found"
    INSTALL_NVIM=true
fi

if $INSTALL_NVIM; then
    echo "[+] Installing Neovim 0.10+ from GitHub..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim-linux64
    sudo tar xzf nvim-linux64.tar.gz -C /opt
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux64.tar.gz
else
    echo "[+] Neovim is up to date"
fi

cd "$DF_DIR"
if ! git remote get-url origin | grep -q 'git@github.com'; then
    echo "[+] Setting SSH remote origin"
    git remote set-url origin git@github.com:gyogy/dotfiles.git
fi

echo "[+] Bootstrapping Neovim plugins with Packer..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "[✓] Done. Restart shell or run: source ~/.bashrc"
