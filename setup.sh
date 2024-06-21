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

# ------ Find USER, HOME, and Operating System ------

USER=${USER:-$(id -un)}
HOME=${HOME:-$(cd ~ && pwd)}
OS=$(check_os)

# ------ Determine Package Manager ------

packageManager=""

if [[ "$OS" == "Darwin" ]]; then 
    if command -v brew &> /dev/null ; then 
        packageManager="brew"
    # TODO: Check if homebrew is installed. If not, install it.
    else
        echo "Homebrew not installed. Exiting..."
        exit 1
    fi
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

# ------ Backup Shell Dotfiles ------

# TODO: Add functionality to restore original configuration.

backupDir=$(get_script_dir)/backups
if [ ! -d "$backupDir" ]; then
    mkdir "$backupDir"
fi

# Backup ~/.bashrc
if [ -f "$HOME/.bashrc" ]; then
    mv "$HOME/.bashrc" "$backupDir/.bashrc.bak"
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

# TODO: Back up .vimrc.

# ------ Install Command Line Tools ------

# TODO: Dynamically locate dotfiles to backup.

# Install Tmux.
if ! command -v tmux &> /dev/null; then 
    echo "[-] tmux is not installed. Installing..."
    $packageManager install tmux
else 
    # Backup ~/.tmux.conf
    if [ -f "$HOME/.tmux.conf" ]; then 
        mv "$HOME/.tmux.conf" "$backupDir/.tmux.conf.bak"    
        echo "[+] Backed up .tmux.conf."
    elif [ -f "$HOME/.config/tmux/tmux.conf" ]; then 
        mv "$HOME/.config/tmux/tmux.conf" "$backupDir/tmux.conf.bak"
        echo "[+] Backed up .tmux.conf."
    else 
        echo "[-] .tmux.conf doesn't exist."
    fi
fi 

# Install Vim.
# TODO: Switch to nvim setup.
if ! command -v vim &> /dev/null; then
    echo "[-] vim is not installed. Installing..."
    $packageManager install vim
fi

# Install Bat.
if ! command -v bat &> /dev/null; then 
    echo "[-] bat is not installed. Installing..."
    $packageManager install bat
fi

# Install FZF.
if ! command -v fzf &> /dev/null; then 
    echo "[-] fzf not installed. Installing..."
    $packageManager install fzf
fi 

# ------ Change Shell in Linux to ZSH ------

if [ "$OS" == "Linux" ]; then
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

# Install oh-my-zsh if not installed.
if [[ "$ZSH" == "$HOME/.oh-my-zsh" ]]; then 
    echo "[+] Oh My Zsh is already installed."
else 
    # Use curl if available, default to wget.
    if command -v curl &> /dev/null; then 
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else 
        sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
fi

# Set Oh My Zsh specific directories.
if [[ -d "$HOME/.oh-my-zsh" ]]; then 
    zshCustom="$HOME/.oh-my-zsh/custom"

    # Copy theme.
    themeDir="$(get_script_dir)/themes"
    cp "$themeDir/mrdebator.zsh-theme" "$zshCustom/themes"
    echo "[+] Copied custom theme."

    # Download plugins.
    if [[ ! -d "$zshCustom/plugins/zsh-autosuggestions" ]]; then 
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zshCustom/plugins/zsh-autosuggestions"
        echo '[+] Installed zsh-autosuggestions.'
    fi
    if [[ ! -d "$zshCustom/plugins/zsh-completions" ]]; then 
        git clone https://github.com/zsh-users/zsh-completions.git "$zshCustom/plugins/zsh-completions"
        echo '[+] Installed zsh-completions.'
    fi 
    if [[ ! -d "$zshCustom/plugins/zsh-syntax-highlighting" ]]; then 
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zshCustom/plugins/zsh-syntax-highlighting"
        echo '[+] Installed zsh-syntax-highlighting.'
    fi
    if [[ ! -d "$zshCustom/plugins/fzf-tab" ]]; then 
        git clone https://github.com/Aloxaf/fzf-tab "$zshCustom/plugins/fzf-tab"
        echo '[+] Installed fzf-tab.'
    fi

fi

dotfilesDir="$(get_script_dir)/dotfiles"
cp "$dotfilesDir/zshrc" "$HOME/.zshrc"
echo "[+] Copied ZSH configuration."

# Add alias for `bat`.
batPath=$(command -v bat || command -v batcat)
if [ -n "$batPath" ]; then
  echo "alias cat=$batPath" >> "$HOME/.zshrc"
fi

# Add alias for updating `locate` database on MacOS
if [ "$OS" == "Darwin" ]; then
    echo 'alias updatedb="/usr/libexec/locate.updatedb"' >> "$HOME/.zshrc"
fi

# ------ Set up tmux ------

# Install necessary fonts.
if [[ "$OS" == "Darwin" ]] && [[ "$packageManager" == "brew" ]]; then
    if [[ ! -d "${HOMEBREW_PREFIX:-/opt/homebrew}/Caskroom/font-jetbrains-mono-nerd-font" ]]; then
        $packageManager install --cask font-jetbrains-mono-nerd-font
    fi
elif [[ "$OS" == "Linux" ]] && [[ ! -f "$HOME/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf" ]]; then
    wget -P "$HOME/.local/share/fonts" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
    unzip "$HOME/.local/share/fonts/JetBrainsMono.zip"
    rm "$HOME/.local/share/fonts/JetBrainsMono.zip"
    fc-cache -fv
fi

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
