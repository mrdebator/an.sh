#!/usr/bin/env bash

# ==============================================================================
#  setup.sh - Modular Dotfiles Orchestrator
# ==============================================================================

set -e

# 1. Source Libraries
# ------------------------------------------------------------------------------
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/system.sh"
source "$SCRIPT_DIR/lib/apps.sh"
source "$SCRIPT_DIR/lib/stow.sh"

# 2. Configuration Manifests
# ------------------------------------------------------------------------------

# Installed on ALL machines
APPS_COMMON=(
    "git"
    "zsh"
    "neovim"
    "tmux"
    "fzf"
    "bat"
    "stow"
    "fonts"
    "curl"
    "wget"
    "alacritty"
    "ripgrep"
    "node"
    "go"
)

# Installed ONLY on Personal machines
APPS_PERSONAL=(
    "obsidian"
    "qflipper"
    "docker"
    "chrome"
    "gcm"
)

# Installed ONLY on Work machines
APPS_WORK=(
    # Add work-specific tools here
    # "slack"
    # "vpn-client"
)

# 3. Argument Parsing
# ------------------------------------------------------------------------------
PROFILE="personal"
TARGET="all"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --work) PROFILE="work" ;;
        --personal) PROFILE="personal" ;;
        --target) TARGET="$2"; shift ;;
        *) log_error "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

log_info "Initializing setup for profile: [ $PROFILE ]"

# 4. Build Execution List
# ------------------------------------------------------------------------------
INSTALL_LIST=("${APPS_COMMON[@]}")

if [[ "$PROFILE" == "personal" ]]; then
    INSTALL_LIST+=("${APPS_PERSONAL[@]}")
elif [[ "$PROFILE" == "work" ]]; then
    INSTALL_LIST+=("${APPS_WORK[@]}")
fi

# 5. Dispatcher Logic
# ------------------------------------------------------------------------------
run_task() {
    local task_name=$1
    local function_name="task_${task_name}"

    if type "$function_name" &>/dev/null; then
        log_info ":: Processing task: $task_name"
        "$function_name"
    else
        log_error "Task definition not found: $function_name"
    fi
}

# 6. Main Execution
# ------------------------------------------------------------------------------

# A. System Updates
sys_update

# B. Run App Tasks
if [[ "$TARGET" != "all" ]]; then
    log_warning "Manual override: Running single target [$TARGET]"
    run_task "$TARGET"
else
    for app in "${INSTALL_LIST[@]}"; do
        run_task "$app"
    done
fi

# C. Stow Dotfiles
# Only run stow if we are doing a full install (TARGET == "all")
if [[ "$TARGET" == "all" ]]; then
    log_info ":: Stowing Dotfiles..."

    # Always stow base packages
    # (You can customize this list if you have packages you don't want everywhere)
    STOW_PACKAGES=(
        "alacritty"
        "nvim"
        "tmux"
        "vim"
        "zsh"
    )
    stow_list "${STOW_PACKAGES[@]}"

    # Profile-specific stowing (if they exist)
    if [[ -d "profiles/$PROFILE" ]]; then
        log_info ":: Applying $PROFILE profile overrides..."
        stow --restow --target="$HOME" --dir="profiles" "$PROFILE"
    fi
fi

# D. Post-Install Hygiene
log_success "Setup Complete!"
echo ""
echo "Next Steps:"
echo "  1. Restart your shell: exec zsh"
echo "  2. Open Neovim to install plugins"
echo ""
