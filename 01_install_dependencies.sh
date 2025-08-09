#!/usr/bin/env bash
set -euo pipefail

HOME_DIR="$HOME"
FORCE=false
[ "${1:-}" = "--force" ] && FORCE=true

require_sudo() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script needs sudo for apt and /usr/local installs."
        sudo -v
    fi
}

ver_ge() {
    a=$(printf "%s" "$1" | awk -F. '{printf "%d.%d.%d", $1,$2,$3?$3:0}')
    b=$(printf "%s" "$2" | awk -F. '{printf "%d.%d.%d", $1,$2,$3?$3:0}')
    dpkg --compare-versions "$a" ge "$b"
}

nvim_installed_ver() {
    if command -v nvim >/dev/null 2>&1; then
        nvim --version | awk 'NR==1{gsub(/^NVIM v/,"",$2); sub(/^v/,"",$2); print $2}'
    else
        echo ""
    fi
}

apt_candidate_ver() {
    apt-cache policy neovim | awk '/Candidate:/ {print $2}'
}

remove_old_nvim() {
    if dpkg -s neovim >/dev/null 2>&1; then
        sudo apt -y purge neovim neovim-runtime || true
        sudo apt -y autoremove || true
    fi
    if [ -x /usr/local/bin/nvim ]; then
        if ! dpkg -S /usr/local/bin/nvim >/dev/null 2>&1; then
            sudo rm -f /usr/local/bin/nvim
        fi
    fi
}

install_nvim_via_apt() {
    sudo apt update
    sudo apt -y install neovim
}

install_nvim_from_source() {
    require_sudo
    sudo apt update
    sudo apt -y install git ninja-build gettext cmake unzip curl build-essential pkg-config

    workdir="$(mktemp -d)"
    trap 'rm -rf "$workdir"' EXIT

    echo "Cloning Neovim (stable branch)..."
    git clone --depth 1 --branch stable https://github.com/neovim/neovim "$workdir/neovim"
    cd "$workdir/neovim"

    echo "Building Neovim (Release)..."
    make CMAKE_BUILD_TYPE=Release
    echo "Installing to /usr/local ..."
    sudo make install

    cd "$HOME_DIR"
}

ensure_nvim_010_plus() {
    local want="0.10.0"
    local cur
    cur="$(nvim_installed_ver || true)"

    if [ "$FORCE" = false ] && [ -n "$cur" ] && ver_ge "$cur" "$want"; then
        echo "Neovim already OK (v$cur)."
        return
    fi

    echo "Installing or updating Neovim..."
    require_sudo
    remove_old_nvim

    cand="$(apt_candidate_ver || true)"
    if [ -n "$cand" ] && ver_ge "$cand" "$want"; then
        echo "Installing Neovim from apt (candidate $cand)..."
        install_nvim_via_apt
    else
        echo "Apt candidate is '$cand' (< $want). Building from source..."
        install_nvim_from_source
    fi

    cur="$(nvim_installed_ver || true)"
    if [ -z "$cur" ] || ! ver_ge "$cur" "$want"; then
        echo "ERROR: Failed to get Neovim >= $want (got '${cur:-none}')." >&2
        exit 1
    fi
    echo "Neovim ready (v$cur)."
}

ensure_tmux() {
    if command -v tmux >/dev/null 2>&1; then
        echo "tmux already installed ($(tmux -V))."
        return
    fi
    require_sudo
    sudo apt update
    sudo apt -y install tmux
    echo "tmux installed ($(tmux -V))."
}

ensure_pyright() {
    if command -v pyright >/dev/null 2>&1; then
        echo "pyright already installed ($(pyright --version 2>/dev/null || echo unknown))."
        return
    fi
    require_sudo
    if ! command -v npm >/dev/null 2>&1; then
        sudo apt update
        sudo apt -y install nodejs npm
    fi
    sudo npm install -g pyright
    echo "pyright installed ($(pyright --version 2>/dev/null || echo unknown))."
}

main() {
    ensure_nvim_010_plus
    ensure_tmux
    ensure_pyright
    echo "All set."
}

main "$@"

