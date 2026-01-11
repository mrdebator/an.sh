# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Path to FZF installation.
export FZF_BASE="$ZSH/plugins/fzf"

# Default Editor
export VISUAL=vim
export EDITOR="$VISUAL"

export PATH="$HOME/.local/bin:$PATH"

# Set theme.
ZSH_THEME="mrdebator"

# Add plugins.
plugins=(
    git
    fzf
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
)

# Source oh-my-zsh.
source $ZSH/oh-my-zsh.sh

# History Optimizations
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HIST_STAMPS="yyyy-mm-dd"

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Allow case-insensitive autocompletions.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Add color to autocompletions.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Shell Integrations
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
fi

# Aliases
if command -v bat &>/dev/null; then
    alias cat="$(command -v bat)"
elif command -v batcat &>/dev/null; then
    alias cat="$(command -v batcat)"
fi
