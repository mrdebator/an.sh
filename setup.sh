#!/bin/zsh

if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
    echo "Detected ZSH shell"

    # Install zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    # Install zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

    # Add plugins to .zshrc
else
    echo "boo"
fi
