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

function is_zsh() {
    # Check environment variable
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

# ------ Check & Install OhMyZsh ------






# TODO: 
# - Install and configure ohmyzsh with mrdebator theme for Mac and Linux
# - Install zsh plugins
# - Install VSCode with preferences and themes



# if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
#     echo "Detected ZSH shell"

#     # Install zsh-autosuggestions
#     git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#     # Install zsh-syntax-highlighting
#     git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

#     # Add plugins to .zshrc
# else
#     echo "boo"
# fi
