#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
HOME_DIR="$HOME"

ITEMS=(.bash_aliases .bash_envvars .bash_functions .bashrc .tmux.conf .vimrc .config/nvim)

timestamp() { date +"%Y%m%d-%H%M%S"; }

backup_needed() {
    local target_path="$1"
    local source_path="$2"

    # Skip if already correctly linked
    if [ -L "$target_path" ] && [ "$(readlink -f "$target_path")" = "$(readlink -f "$source_path")" ]; then
        echo "✓ Already linked: $target_path"
        return 1
    fi

    # Backup if exists or is a symlink
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        local backup_path="${target_path}.bak"
        if [ -e "$backup_path" ] || [ -L "$backup_path" ]; then
            backup_path="${backup_path}.$(timestamp)"
        fi
        mv -v -- "$target_path" "$backup_path"
    fi

    return 0
}

link_item() {
    local relative_path="$1"
    local source_path="$DOTFILES_DIR/$relative_path"
    local target_path="$HOME_DIR/$relative_path"

    # Only process if the source exists in the repo
    [ -e "$source_path" ] || return 0

    mkdir -p -- "$(dirname "$target_path")"

    if backup_needed "$target_path" "$source_path"; then
        ln -s -- "$source_path" "$target_path"
        echo "→ Linked: $target_path -> $source_path"
    fi
}

mkdir -p -- "$HOME_DIR/.config"

for item in "${ITEMS[@]}"; do
    link_item "$item"
done

echo "Done."

