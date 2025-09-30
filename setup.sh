#!/usr/bin/env bash

# ================================================================
#  Dotfiles Setup Script with GNU Stow
# ================================================================

set -euo pipefail  # Exit on error, undefined variable, or pipe failure

# ------ Color Output Functions ------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[+]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[-]${NC} $1"
    exit 1
}

# ------ Helper Functions ------

check_os() {
    case "$(uname -s)" in
        Linux*)     echo "Linux";;
        Darwin*)    echo "Darwin";;
        *)          log_error "Unsupported OS: $(uname -s)";;
    esac
}

# Use a combination of readlink and dirname to determine location of script.
function get_script_dir() {
    # BASH_SOURCE[0] holds the path to the currently executing script.
    SOURCE="${BASH_SOURCE[0]}"
    # Use a loop to handle the case where the script may be a symlink.
    while [[ -L "$SOURCE" ]]; do
        # Use a subshell and `dirname` to resolve the directory containing the symlink.
        DIR="$( cd -P "$( dirname "$SOURCE" )" &> /dev/null && pwd )"
        # Resolve symlink using `readlink`.
        SOURCE="$(readlink "$SOURCE")"
        # Handle relative symlinks.
        [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
    done
    DIR="$( cd -P "$( dirname "$SOURCE" )" &> /dev/null && pwd )"
    echo "$DIR"
}

detect_package_manager() {
    if [[ "$OS" == "Darwin" ]]; then
        if command -v brew &>/dev/null; then
            echo "brew"
        else
            log_error "Homebrew not installed. Please install from https://brew.sh"
        fi
    elif command -v apt &>/dev/null; then
        echo "apt"
    elif command -v pacman &>/dev/null; then
        echo "pacman"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v yum &>/dev/null; then
        echo "yum"
    else
        log_error "No supported package manager found"
    fi
}

# ------ System Detection ------

OS=$(check_os)
DOTFILES_DIR=$(get_script_dir)
PACKAGE_MANAGER=$(detect_package_manager)
HOME=${HOME:-$(cd ~ && pwd)}

log_info "Operating System: $OS"
log_info "Package Manager: $PACKAGE_MANAGER"
log_info "Dotfiles Directory: $DOTFILES_DIR"

# ------ Install GNU Stow ------

if ! command -v stow &>/dev/null; then
    log_warning "GNU Stow is not installed. Installing..."
    case "$PACKAGE_MANAGER" in
        brew)
            brew install stow
            ;;
        apt)
            sudo apt update && sudo apt install -y stow
            ;;
        pacman)
            sudo pacman -Sy --noconfirm stow
            ;;
        dnf|yum)
            sudo $PACKAGE_MANAGER install -y stow
            ;;
        *)
            log_error "Cannot install stow with $PACKAGE_MANAGER"
            ;;
    esac
    if ! command -v stow &>/dev/null; then
        log_error "Failed to install GNU Stow. Aborting setup."
    fi
else
    log_success "GNU Stow is already installed"
fi

# ------ Create Backups ------

BACKUP_DIR="$DOTFILES_DIR/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
log_info "Backup directory created at: $BACKUP_DIR"

backup_if_exists() {
  local target="$1"
  # Check if the target exists and is not already a symlink
  if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
    log_info "Backing up '$target' to '$BACKUP_DIR'"
    # Move the original file/directory to the backup location
    mv "$target" "$BACKUP_DIR/"
  fi
}

# Backup existing configs that aren't symlinks
declare -a configs=(
    "$HOME/.zshrc"
    "$HOME/.bashrc"
    "$HOME/.vimrc"
    "$HOME/.tmux.conf"
    "$HOME/.gitconfig"
    "$HOME/.config/nvim"
    "$HOME/.config/tmux"
)

for config in "${configs[@]}"; do
    backup_if_exists "$config"
done


# ------ Install Required Tools ------

install_tool() {
    local tool=$1
    local package=${2:-$tool}  # Use second argument if provided, otherwise use tool name

    if ! command -v "$tool" &>/dev/null; then
        log_info "Installing $tool..."
        case "$PACKAGE_MANAGER" in
            brew)
                brew install "$package"
                ;;
            apt)
                sudo apt install -y "$package"
                ;;
            pacman)
                sudo pacman -S --noconfirm "$package"
                ;;
            dnf|yum)
                sudo $PACKAGE_MANAGER install -y "$package"
                ;;
        esac
    else
        log_success "$tool is already installed"
    fi
}

# Essential tools
install_tool git
install_tool curl
install_tool wget
install_tool alacritty

# Development tools
install_tool tmux
install_tool zsh
install_tool nvim neovim
install_tool rg ripgrep
install_tool fzf
install_tool bat

# Neovim dependencies
install_tool node nodejs
install_tool go golang

# fd has different package names
if ! command -v fd &>/dev/null; then
    log_info "Installing fd..."
    case "$PACKAGE_MANAGER" in
        brew)
            brew install fd
            ;;
        apt)
            sudo apt install -y fd-find
            # Create symlink for consistency
            sudo ln -sf "$(which fdfind)" /usr/local/bin/fd 2>/dev/null || true
            ;;
        pacman)
            sudo pacman -S --noconfirm fd
            ;;
        dnf|yum)
            sudo $PACKAGE_MANAGER install -y fd-find
            ;;
    esac
fi

# Install Python3 and pip
if ! command -v python3 &>/dev/null; then
    install_tool python3 python3
fi

if ! command -v pip3 &>/dev/null; then
    case "$PACKAGE_MANAGER" in
        brew)
            # pip comes with python3 on brew
            ;;
        apt)
            sudo apt install -y python3-pip
            ;;
        pacman)
            sudo pacman -S --noconfirm python-pip
            ;;
        dnf|yum)
            sudo $PACKAGE_MANAGER install -y python3-pip
            ;;
    esac
fi

# Install build tools for treesitter
log_info "Installing build tools..."
case "$PACKAGE_MANAGER" in
    brew)
        # Xcode command line tools should already be installed
        ;;
    apt)
        sudo apt install -y build-essential
        ;;
    pacman)
        sudo pacman -S --noconfirm base-devel
        ;;
    dnf|yum)
        sudo $PACKAGE_MANAGER groupinstall -y "Development Tools"
        ;;
esac

# ------ Install Oh My Zsh ------

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log_info "Installing Oh My Zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
else
    log_success "Oh My Zsh is already installed"
fi

# Install Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

install_zsh_plugin() {
    local repo=$1
    local name=$2

    if [[ ! -d "$ZSH_CUSTOM/plugins/$name" ]]; then
        log_info "Installing $name..."
        git clone "$repo" "$ZSH_CUSTOM/plugins/$name"
    else
        log_success "$name is already installed"
    fi
}

install_zsh_plugin "https://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
install_zsh_plugin "https://github.com/zsh-users/zsh-completions" "zsh-completions"
install_zsh_plugin "https://github.com/zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting"

# ------ Install Fonts ------

install_nerd_font() {
    log_info "Installing JetBrains Mono Nerd Font..."

    if [[ "$OS" == "Darwin" ]]; then
        brew install --cask font-jetbrains-mono-nerd-font || true
    else
        # Linux installation
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR"

        if [[ ! -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]]; then
            cd /tmp
            wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
            unzip -q JetBrainsMono.zip -d "$FONT_DIR"
            rm JetBrainsMono.zip
            fc-cache -fv
            cd - >/dev/null
        fi
    fi
}

install_nerd_font

# ------ Stow Dotfiles ------

# Stow all packages
# The directory structure should be:
# an.sh/
# ├── setup.sh              # Your main installer script.
# ├── README.md
# ├── LICENSE
# ├── archive/              # (Skipped by Stow)
# ├── backups/              # (Skipped by Stow)
#
# # -------------------------------------------------------------------
# # STOW PACKAGES: Each directory below is a "package".
# # The script will automatically find and stow each of these.
# # -------------------------------------------------------------------
#
# ├── alacritty/            # Alacritty
# │   └── .config/
# │       └── alacritty/
# │           └── alacritty.toml
# │
# ├── git/                  # Git
# │   └── .gitconfig
# │
# ├── nvim/                 # NeoVim
# │   └── .config/
# │       └── nvim/
# │           ├── init.lua
# │           └── lua/
# │               ├── core/
# │               └── plugins/
# │
# ├── tmux/                 # Tmux
# │   └── .config/
# │       └── tmux/
# │           └── tmux.conf
# │
# ├── vim/                  # Vim
# │   └── .vimrc
# │
# └── zsh/                         # Zsh package
#     ├── .zshrc
#     └── .oh-my-zsh/              # Optional: custom themes/plugins
#         └── custom/
#             └── themes/
#                 └── mrdebator.zsh-theme


BACKUP_DIR="$DOTFILES_DIR/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
log_info "Backups for this run will be stored in: $BACKUP_DIR"
log_info "Preparing to stow dotfiles from $DOTFILES_DIR"
cd "$DOTFILES_DIR"

# Automatically find and stow all packages
# This loop will find any directory that is a valid stow package (i.e., not 'backups' or hidden).
stow_packages() {
    for package_dir in */; do
        # Remove trailing slash to get the package name
        local package=${package_dir%/}

        # Skip directories that are not stow packages
        if [[ "$package" == "backups" || "$package" == "themes" || "$package" == "system" || "$package" == "tools" || "$package" == "archive" ]]; then
            continue
        fi

        # Before stowing, we need to handle potential conflicts
        log_info "Preparing to stow '$package'..."
        # This is a bit complex: it finds all files within the package dir and checks for conflicts in the home dir
        find "$package" -mindepth 1 -maxdepth 1 -print0 | while IFS= read -r -d $'\0' item; do
            target="$HOME/$(basename "$item")"
            if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
                log_warning "Found existing config at '$target'. Backing it up."
                mv "$target" "$BACKUP_DIR/"
            fi
        done

        # Now, safely stow the package
        stow --restow --target="$HOME" "$package"
        log_success "successfully stowed '$package'"
    done
}

stow_packages
log_success "All packages have been stowed successfully!"

# ------ Post-Installation Setup ------

# Set Zsh as default shell
if [[ "$SHELL" != "$(which zsh)" ]]; then
    log_info "Setting Zsh as default shell..."
    chsh -s "$(which zsh)" || log_warning "Failed to set Zsh as default shell"
fi

# ------ Success Message ------

echo ""
echo "================================================================"
echo "                    Setup Complete!"
echo "================================================================"
echo ""
log_success "All dotfiles have been stowed successfully!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open Neovim and wait for plugins to install: nvim"
echo "  3. Check Neovim health: :checkhealth"
echo ""
echo "To manage your dotfiles:"
echo "  - Add new configs: stow <package>"
echo "  - Remove configs: stow -D <package>"
echo "  - Restow configs: stow -R <package>"
echo ""
echo "Backups saved to: $BACKUP_DIR"
echo "================================================================"
