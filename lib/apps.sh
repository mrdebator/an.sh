#!/usr/bin/env bash

# ==============================================================================
#  lib/apps.sh - Application-Specific Installation Logic
# ==============================================================================

# Ensure dependencies are loaded
if [ -z "$(command -v log_info)" ]; then
    source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/system.sh"
fi

# ------------------------------------------------------------------------------
#  Helper: GitHub AppImage Installer
# ------------------------------------------------------------------------------
# Arguments:
#   $1: App Name (e.g., "Obsidian")
#   $2: GitHub Repo (e.g., "obsidianmd/obsidian-releases")
#   $3: Search Pattern (e.g., "AppImage" or "x86_64.*AppImage")
install_github_appimage() {
    local app_name=$1
    local repo=$2
    local search_term=$3

    local app_dir="$HOME/Applications/$app_name"
    local bin_dir="$HOME/.local/bin"
    local version_file="$app_dir/version.txt"

    mkdir -p "$app_dir" "$bin_dir"

    log_info "Checking latest version for $app_name..."

    # 1. Get the latest release tag
    local latest_tag
    latest_tag=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [[ -z "$latest_tag" ]]; then
        log_warning "Could not fetch release info for $app_name. Skipping."
        return
    fi

    # 2. Check installed version
    local current_version=""
    if [[ -f "$version_file" ]]; then
        current_version=$(cat "$version_file")
    fi

    if [[ "$current_version" == "$latest_tag" ]]; then
        log_success "$app_name is already up to date ($latest_tag)"
        return
    fi

    log_info "Updating $app_name ($current_version -> $latest_tag)..."

    # 3. Find the download URL
    local download_url
    download_url=$(curl -s "https://api.github.com/repos/$repo/releases/latest" \
        | grep "browser_download_url" \
        | grep -i "$search_term" \
        | grep -v "arm64" \
        | cut -d '"' -f 4 \
        | head -n 1)

    if [[ -z "$download_url" ]]; then
        log_error "Could not find asset for $app_name matching '$search_term'"
        return
    fi

    # 4. Download and Install
    local filename="${app_name}.AppImage"

    # Clean old versions
    rm -f "$app_dir/"*.AppImage

    log_info "Downloading from $download_url..."
    wget -q --show-progress -O "$app_dir/$filename" "$download_url"
    chmod +x "$app_dir/$filename"

    # 5. Extract (to avoid FUSE issues) and Link
    # Note: We extract to 'binary' folder so the path is stable for .desktop files
    cd "$app_dir"
    ./"$filename" --appimage-extract >/dev/null
    rm -rf binary
    mv squashfs-root binary
    rm "$filename" # Delete the big AppImage file after extraction

    # Update Symlink for CLI access
    ln -sf "$app_dir/binary/AppRun" "$bin_dir/${app_name,,}"

    # Save Version
    echo "$latest_tag" > "$version_file"

    log_success "$app_name updated to $latest_tag"
}


# ------------------------------------------------------------------------------
#  Tasks: Core Tools (Wrappers)
# ------------------------------------------------------------------------------

# Essential tools
task_curl()         { sys_install "curl"; }
task_wget()         { sys_install "wget"; }
task_git()          { sys_install "git"; }
task_alacritty()    { sys_install "alacritty"; }

# Development tools
task_zsh()      { sys_install "zsh"; }
task_tmux()     { sys_install "tmux"; }
task_fzf()      { sys_install "fzf"; }
task_bat()      { sys_install "bat"; }
task_stow()     { sys_install "stow"; }
task_neovim()   { sys_install "nvim" "neovim"; }
task_ripgrep()  { sys_install "rg" "ripgrep"; }

# Neovim dependencies
task_node() { sys_install "node" "nodejs"; }
task_go()   { sys_install "go" "golang"; }

# ------------------------------------------------------------------------------
#  Tasks: Complex Apps (Personal / Manual)
# ------------------------------------------------------------------------------

task_obsidian() {
    if [[ "$(get_os)" == "Darwin" ]]; then
        # macOS: Use Homebrew Cask
        # We check simply by seeing if the app exists in /Applications
        if [[ ! -d "/Applications/Obsidian.app" ]]; then
            log_info "Installing Obsidian (Cask)..."
            brew install --cask obsidian
        else
            log_success "Obsidian is already installed."
        fi
    else
        # Linux: Use AppImage
        install_github_appimage "Obsidian" "obsidianmd/obsidian-releases" "AppImage"
        # Ensure the .desktop file exists (we only need to create this once)
        local desktop_file="$HOME/.local/share/applications/obsidian.desktop"
        if [[ ! -f "$desktop_file" ]]; then
            log_info "Creating Obsidian launcher..."
            mkdir -p "$(dirname "$desktop_file")"

            # Download Icon
            wget -q -O "$HOME/Applications/Obsidian/icon.svg" "https://upload.wikimedia.org/wikipedia/commons/1/10/2023_Obsidian_logo.svg"

            cat <<EOF > "$desktop_file"
[Desktop Entry]
Name=Obsidian
Exec=$HOME/Applications/Obsidian/binary/AppRun
Icon=$HOME/Applications/Obsidian/icon.svg
Type=Application
Categories=Office;
Terminal=false
MimeType=x-scheme-handler/obsidian;
EOF
            update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
        fi
    fi
}

task_chrome() {
    if [[ "$(get_os)" == "Darwin" ]]; then
        # macOS: Use Homebrew Cask
        # We check simply by seeing if the app exists in /Applications
        if [[ ! -d "/Applications/Google Chrome.app" ]]; then
            log_info "Installing Google Chrome (Cask)..."
            brew install --cask google-chrome
        else
            log_success "Google Chrome is already installed."
        fi
    elif [[ "$(detect_package_manager)" == "dnf" ]]; then
            sys_enable_fedora_repos
            sys_install "google-chrome-stable"
    else
        log_warning "Chrome install logic only implemented for MacOS and Fedora (dnf) currently."
    fi
}

task_docker() {
    if [[ "$(get_os)" == "Darwin" ]]; then
        if [[ ! -d "/Applications/Docker.app" ]]; then
            log_info "Installing Docker (Cask)..."
            brew install --cask docker
        else
            log_success "Docker is already installed."
        fi
    else
        # Linux: DNF Logic
        if command -v docker &>/dev/null; then
            log_success "Docker is already installed"
            return
        fi

        log_info "Installing Docker..."
        if [[ "$(detect_package_manager)" == "dnf" ]]; then
            sudo dnf -y install dnf-plugins-core

            log_info "Adding Docker repository..."
            sudo curl -fsSL -o /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/fedora/docker-ce.repo

            sys_install "docker-ce"
            sys_install "docker-ce-cli"
            sys_install "containerd.io"
            sys_install "docker-buildx-plugin"
            sys_install "docker-compose-plugin"

            # Enable service
            sudo systemctl enable --now docker

            # Add user to group
            sudo usermod -aG docker $USER || true
            log_warning "Docker installed. You must LOGOUT and LOGIN for group permissions to take effect."
        else
            log_warning "Docker install skipped (Logic only for DNF currently)"
        fi
    fi
}

task_gcm() {
    # --- macOS Logic ---
    if [[ "$(get_os)" == "Darwin" ]]; then
        if command -v git-credential-manager &>/dev/null; then
            log_success "GCM is already installed."
        else
            log_info "Installing GCM (Cask)..."
            brew install --cask git-credential-manager
            # Mac automatically configures itself to use Keychain; no extra config needed.
        fi
        return
    fi

    # --- Linux Logic ---
    if command -v git-credential-manager &>/dev/null; then
        log_success "Git Credential Manager is already installed"
        return
    fi

    log_info "Installing Git Credential Manager..."

    local gcm_repo="git-ecosystem/git-credential-manager"
    local download_url
    download_url=$(curl -s "https://api.github.com/repos/$gcm_repo/releases/latest" \
        | grep "browser_download_url" \
        | grep "linux_x64.*tar.gz" \
        | cut -d '"' -f 4 \
        | head -n 1)

    if [[ -z "$download_url" ]]; then
        log_error "Could not find GCM download url"
        return
    fi

    local tmp_dir="/tmp/gcm_install"
    mkdir -p "$tmp_dir"
    wget -q -O "$tmp_dir/gcm.tar.gz" "$download_url"

    sudo tar -xvf "$tmp_dir/gcm.tar.gz" -C /usr/local/bin git-credential-manager >/dev/null
    sudo chmod +x /usr/local/bin/git-credential-manager

    # Configure Git (Linux Only)
    git-credential-manager configure
    git config --global credential.credentialStore secretservice

    # Cleanup
    rm -rf "$tmp_dir"

    log_success "GCM Installed and Configured!"
}

task_qflipper() {
    if [[ "$(get_os)" == "Darwin" ]]; then
        if [[ ! -d "/Applications/qFlipper.app" ]]; then
            brew install --cask qflipper
        fi
    else
        # Found in Fedora repos, fallback to AppImage if not on Fedora/DNF
        if [[ "$(detect_package_manager)" == "dnf" ]]; then
            sys_install "qflipper"
        else
            install_github_appimage "qFlipper" "flipperdevices/qFlipper" "x86_64.*AppImage"
        fi
    fi
}

task_fonts() {
    # Determine the correct font directory based on OS
    local font_dir
    if [[ "$(get_os)" == "Darwin" ]]; then
        font_dir="$HOME/Library/Fonts"
    else
        font_dir="$HOME/.local/share/fonts"
    fi

    if [[ ! -f "$font_dir/JetBrainsMonoNerdFont-Regular.ttf" ]]; then
        log_info "Installing Nerd Fonts to $font_dir..."
        mkdir -p "$font_dir"
        local tmp_zip="/tmp/nerdfont.zip"

        # Use curl on Mac if wget isn't there, or just stick to wget if you installed it via brew
        if command -v wget &>/dev/null; then
            wget -q -O "$tmp_zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
        else
            curl -fsSL -o "$tmp_zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
        fi

        unzip -q -o "$tmp_zip" -d "$font_dir"
        rm "$tmp_zip"

        # Update cache (Linux only)
        if [[ "$(get_os)" == "Linux" ]]; then
            fc-cache -fv >/dev/null
        fi

        log_success "Fonts installed"
    else
        log_success "Fonts already installed"
    fi
}
