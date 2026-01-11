#!/usr/bin/env bash

# ==============================================================================
#  lib/stow.sh - Dotfile Linking with GNU Stow
# ==============================================================================

# Ensure dependencies
if [ -z "$(command -v log_info)" ]; then
    source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/system.sh"
fi

stow_backup_conflict() {
    local target="$1"
    local backup_dir="$2"
    local source_file="$3"

    # If target doesn't exist, no conflict.
    if [[ ! -e "$target" ]]; then
        return
    fi

    # CRITICAL SAFETY CHECK:
    # If the target ans source resolve to the exact same physical file,
    # it means we are already linked (perhaps via a parent directory symlink).
    # Do NOT move it.
    if [[ "$(realpath "$target")" == "$(realpath "$source_file")" ]]; then
        log_info "target '$target' is already linked to source. Skipping backup."
        return
    fi

    # If it's a real (and not a symlink pointing elsewhere), back it up.
    if [[ ! -L "$target" ]]; then
        log_warning "Conflict found: '$target'. Moving to backup."
        mv "$target" "$backup_dir/"
    fi
}

stow_package() {
    local pkg="$1"
    local target_home="${2:-$HOME}"
    local dotfiles_root
    dotfiles_root=$(get_script_dir)/..

    log_info "Stowing package: [$pkg]"

    # 1. Check if package exists
    if [[ ! -d "$dotfiles_root/$pkg" ]]; then
        log_error "Stow package not found: $dotfiles_root/$pkg"
        return 1
    fi

    # 2. Prepare Backup Directory for this run
    local backup_dir="$dotfiles_root/backups/$(date +%Y%m%d_%H%M%S)_$pkg"
    mkdir -p "$backup_dir"

    # 3. Conflict Resolution (Surgical)
    # Stow will fail if a file exists where it wants to put a symlink.
    # We walk through the package structure to find conflicts in $HOME.

    find "$dotfiles_root/$pkg" -type f | while read -r source_file; do
        # Strip the repo path to get the relative path (e.g., .config/nvim/init.lua)
        local rel_path="${source_file#$dotfiles_root/$pkg/}"
        local target_path="$target_home/$rel_path"

        # Ensure parent dir exists so realpath doesn't error on dir
        mkdir -p "$(dirname "$target_path")"

        # Check if the target exists and is a real file (not a symlink)
        stow_backup_conflict "$target_path" "$backup_dir" "$source_file"
    done

    # 4. Remove empty backup dir if no conflicts were found
    rmdir "$backup_dir" 2>/dev/null

    # 5. Run Stow
    # -v: verbose
    # -R: restow (prune old links, make new ones)
    # -t: target directory
    # -d: dotfiles dir
    stow -v -R -t "$target_home" -d "$dotfiles_root" "$pkg"

    if [[ $? -eq 0 ]]; then
        log_success "Stowed $pkg"
    else
        log_error "Stow failed for $pkg"
    fi
}

# Wrapper to stow a list of packages
stow_list() {
    # arguments: array of packages passed as names
    for pkg in "$@"; do
        stow_package "$pkg"
    done
}
