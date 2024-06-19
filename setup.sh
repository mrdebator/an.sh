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

if command -v apt &> /dev/null ; then 
    packageManager="apt"
elif command -v brew &> /dev/null ; then 
    packageManager="brew"
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

# ------ Backup Shell Dotfiles ------

# TODO: Add functionality to restore original configuration.

backupDir=$(get_script_dir)/.dotfiles.bak
if [ ! -d "$backupDir" ]; then
    mkdir "$backupDir"
fi

# Backup ~/.bashrc
if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$backupDir/.bashrc.bak"
    echo "[+] Backed up .bashrc"
else 
    echo "[-] .bashrc doesn't exist"
fi
# Backup ~/.zshrc
if [ -f "$HOME/.zshrc" ]; then 
    cp "$HOME/.zshrc" "$backupDir/.zshrc.bak"
    echo "[+] Backed up .zshrc"
else 
    echo "[-] .zshrc doesn't exist"
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
        echo "[+] Backed up .tmux.conf"
    else 
        echo "[-] .tmux.conf doesn't exist"
    fi
fi 

# TODO: Switch to nvim setup.
if ! command -v vim &> /dev/null; then
    echo "[-] vim is not installed. Installing..."
    $packageManager install vim
    # TODO: Back up .vimrc.
fi



# 


# TODO: 
# - Install and configure ohmyzsh with mrdebator theme for Mac and Linux
# - Install zsh plugins
# - Install VSCode with preferences and themes



# if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
#     echo "Detected ZSH shell"

#     # Install zsh-autosuggestions
#     git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#     # Install zsh-autosuggestions
#     git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#     # Install zsh-autosuggestions
#     git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#     # Install zsh-syntax-highlighting
#     git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
#     # Install zsh-syntax-highlighting
#     git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
#     # Install zsh-syntax-highlighting
#     git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

#     # Add plugins to .zshrc
# else
#     echo "boo"
# fi
#     # Add plugins to .zshrc
# else
#     echo "boo"
# fi
#     # Add plugins to .zshrc
# else
#     echo "boo"
# fi
