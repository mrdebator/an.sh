#!/usr/bin/env bash

# ==============================================================================
#  lib/system.sh - Package Management Abstraction
# ==============================================================================

# Ensure Utils are loaded
if [ -z "$(command -v log_info)" ]; then
    source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"
fi

# Cache the package manager to avoid re-detecting every time
PM=$(detect_package_manager)

# ------ Core Functions ------

# Update system repositories
sys_update() {
    log_info "Updating package repositories..."

    case "$PM" in
        dnf)
            # DNF check-update returns exit code 100 if updates are available.
            sudo dnf check-update >/dev/null || [ $? -eq 100 ]
            ;;
        apt)
            sudo apt update
            ;;
        brew)
            brew update
            ;;
        pacman)
            sudo pacman -Sy
            ;;
        *)
            log_warning "Update skipped: Unknown package manager"
            ;;
    esac
}

# Install a package using the detected manager
# Usage: sys_install "package_name"
sys_install() {
    local tool=$1
    local pkg=${2:-$tool} # Use second argument if provided, otherwise use tool name.

    # Skip if already installed (Basic check, can be overridden by specific tasks)
    # NOTE: We're relying on the PM's own idempotency mostly,
    # but strictly checking commands is safer in some contexts.
    # For now, we let the PM handle "Already installed" messages.

    case "$PM" in
        dnf)
            sudo dnf install -y "$pkg"
            ;;
        apt)
            sudo apt install -y "$pkg"
            ;;
        brew)
            brew install "$pkg"
            ;;
        pacman)
            sudo pacman -S --noconfirm "$pkg"
            ;;
        *)
            log_error "Cannot install '$pkg': Unknown package manager"
            return 1
            ;;
    esac
}

# ------ Fedora Specifics ------

# Enable the generic workstation repositories (needed for Chrome, etc)
sys_enable_fedora_repos() {
    if [[ "$PM" == "dnf" ]]; then
        if ! rpm -q fedora-workstation-repositories &>/dev/null; then
            log_info "Enabling Fedora Workstation Repositories..."
            sys_install "fedora-workstation-repositories"
        fi
    fi
}
