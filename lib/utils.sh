#!/usr/bin/env bash

# ==============================================================================
#  lib/utils.sh - Core Helpers and Logging
# ==============================================================================

# ------ Color Definitions ------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ------ Logging Functions ------
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
}

log_fatal() {
    echo -e "${RED}[FATAL]${NC} $1"
    exit 1
}

# ------ System Detection ------

get_os() {
    case "$(uname -s)" in
        Linux*)  echo "Linux" ;;
        Darwin*) echo "Darwin" ;;
        *)       echo "Unknown" ;;
    esac
}

# Read the distribution ID.
get_distro() {
    if [[ "$(get_os)" == "Linux" ]] && [[ -f /etc/os-release ]]; then
        # Source the file in a subshell to avoid polluting variables.
        (source /etc/os-release && echo "$ID")
    else
        echo "unknown"
    fi
}

detect_package_manager() {
    if [[ "$(get_os)" == "Darwin" ]]; then
        if command -v brew &>/dev/null; then
            echo "brew"
        else
            log_fatal "Homebrew not found. Please install it from https://brew.sh"
        fi
    else
        # Prefer specific distro checks over just checking binaries.
        local distro=$(get_distro)
        case "$distro" in
            fedora|rhel|centos) echo "dnf" ;;
            debian|ubuntu|pop)  echo "apt" ;;
            arch|manjaro)       echo "pacman" ;;
            *)
                # Fallback: Check binaries if distro detection fails
                if command -v dnf &>/dev/null; then echo "dnf";
                elif command -v apt &>/dev/null; then echo "apt";
                elif command -v pacman &>/dev/null; then echo "pacman";
                else echo "unknown"; fi
                ;;
        esac
    fi
}

# ------ Path Helpers ------

# Robustly fidn the directory where the script is stored.
# Uses 'local' variables to ensure safety when sourced by other scripts.
get_script_dir() {
    # BASH_SOURCE[0] holds the path to the currently executing script.
    local source="${BASH_SOURCE[0]}"
    # Resolve $source until the file is no longer a symlink.
    while [ -h "$source" ]; do
        local dir="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"
        source="$(readlink "$source")"
        [[ $source != /* ]] && source="$dir/$source" # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    echo "$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"
}
