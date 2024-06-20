#!/usr/bin/env bash

# ------ Helper Functions ------

function check_os() {
    # Use uname for portability.
    os=$(uname -s)

    case $os in
        Linux)
            echo "Linux"
            ;;
        Darwin)
            echo "Darwin"
            ;;
        *)
            echo "$os"
            ;;
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

# ------ Set Shell Options ------

# Exit with an error when an unset variable is encountered.
set -o nounset

# Exit on first error.
set -o errexit

# Split shell arguments using whitespaces (like bash). Force result to be 'true' to avoid script termination.
set -o shwordsplit 2>/dev/null || true 

# ------ Find USER and HOME ------

USER=${USER:-$(id -un)}
HOME=${HOME:-$(cd ~ && pwd)}

# ------ Determine Package Manager ------

packageManager=""

if command -v brew &> /dev/null ; then 
    packageManager="brew"
    # TODO: Check if homebrew is installed. If not, install it.
elif command -v apt &> /dev/null ; then 
    packageManager="apt"
elif command -v pacman &> /dev/null ; then 
    packageManager="pacman"
fi

echo "[+] Primary package manager: $packageManager"

# ------ Ensure `git` is Installed ------

if ! command -v git &> /dev/null; then 
    echo "[-] Git is not installed. Installing..."
    $packageManager install git
fi

# TODO: Add code block here to automatically pull the latest changes of this repository before proceeding.

# ------ Ensure `git` is Installed ------

if ! command -v git &> /dev/null; then 
    echo "[-] Git is not installed. Installing..."
    $packageManager install git
fi

# TODO: Add code block here to automatically pull the latest changes of this repository before proceeding.

# ------ Backup Shell Dotfiles ------

# TODO: Add functionality to restore original configuration.

backupDir=$(get_script_dir)/backups
if [ ! -d "$backupDir" ]; then
    mkdir "$backupDir"
fi

# Backup ~/.bashrc
if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$backupDir/.bashrc.bak"
    echo "[+] Backed up .bashrc."
else 
    echo "[-] .bashrc doesn't exist."
fi
# Backup ~/.zshrc
if [ -f "$HOME/.zshrc" ]; then 
    cp "$HOME/.zshrc" "$backupDir/.zshrc.bak"
    echo "[+] Backed up .zshrc."
else 
    echo "[-] .zshrc doesn't exist."
fi

# ------ Install Command Line Tools ------

# TODO: Dynamically locate dotfiles to backup.

if ! command -v tmux &> /dev/null; then 
    echo "[-] tmux is not installed. Installing..."
    $packageManager install tmux
else 
    # Backup ~/.tmux.conf
    if [ -f "$HOME/.tmux.conf" ]; then 
        cp "$HOME/.tmux.conf" "$backupDir/.tmux.conf.bak"    
        echo "[+] Backed up .tmux.conf."
    else 
        echo "[-] .tmux.conf doesn't exist."
    fi
fi 

# TODO: Switch to nvim setup.
if ! command -v vim &> /dev/null; then
    echo "[-] vim is not installed. Installing..."
    $packageManager install vim
    # TODO: Back up .vimrc.
fi

# TODO: Add support for fzf.

# ------ Change Shell in Linux to ZSH ------

if [ "$(check_os)" == "Linux" ]; then
    if command -v zsh &> /dev/null ; then 
        case $- in 
            *i*)
                case "$(getent passwd "${USER}" | cut -d: -f7)" in 
                    */zsh)
                        ;;
                    *)
                        if [ "$(id)" -ne 0 ] ; then
                            echo "Enter password to change shell." >&2
                        fi
                        chsh -s "$(command -v zsh)"
                        ;;
                esac

        esac
    fi
fi

# ------ Set up .zshrc ------

dotfilesDir=$(get_script_dir)/dotfiles

cp "$dotfilesDir/zshrc" "$HOME/.zshrc"
echo "[+] Copied ZSH configuration."

if [ "$(check_os)" == "Darwin" ]; then
    echo 'alias updatedb="/usr/libexec/locate.updatedb"' >> "$HOME/.zshrc"
fi

# ------ Set up tmux ------

# Set up tmux directory.
tmuxDir="${XDG_CONFIG_HOME:-${HOME}/.config}/tmux"

# Install catppuccin tmux theme. (https://github.com/catppuccin/tmux?tab=readme-ov-file#installation)
if [ ! -d "$tmuxDir/plugins/catppuccin" ]; then
    echo "[-] Catppuccin not installed. Installing..."
    git clone https://github.com/catppuccin/tmux.git "$tmuxDir/plugins/catppuccin"
fi

cp "$dotfilesDir/tmux.conf" "$tmuxDir/tmux.conf"
echo "[+] Copied TMUX configuration."

# TODO: Add section to set up VSCode.
