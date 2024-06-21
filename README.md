# My Skeleton Scripts \& Dotfiles

A professor once made the 'dad' joke that my name is technically the 'an' shell, hence the repository name.

## About

This is a repository of configuration files that I like to have on all machines. The configurations are meant to work on default terminal applications to avoid additional setup of iTerm2, Alacritty, etc.

## Prerequisites

- Doesn't work on Windows. Probably never will.
- Need a package manager installed.

## Usage

Clone this repository and run `setup.sh`.

## Specifics

### Command Line Tools

- [Git](https://github.com/git/git)
- [Bat: A cat clone with wings](https://github.com/sharkdp/bat)
- [Vim](https://github.com/vim/vim)
- [Tmux](https://github.com/tmux/tmux)

### ZSH

- Changes the default shell to `zsh`.
- Backs up existing dotfiles.
- Installs [OhMyZsh](https://github.com/ohmyzsh/ohmyzsh). [Zinit](https://github.com/zdharma-continuum/zinit) isn't portable enough yet.
- Installs plugins:
  - ZSH Auto Suggestions
  - ZSH Completions
  - ZSH Syntax Highlighting
- Adds helpful aliases:
  - Aliases `cat` to `bat`.
  - Aliases `updatedb` to `/usr/libexec/locate.updatedb` (MacOS only).

### TMUX

- Enables 256 colors.
- Starts numbering at 1 instead of 0.
- Uses [Catppuccin](https://github.com/catppuccin/tmux) Mocha theme.
- Change prefix key from ^B to ^A.
- New panes open in the current working directory.
- Remaps vertical splits to `|` instead of `%`.
- Remaps horizontal splits to `-` instead of `"`.
- Allows Alt+Arrow Keys to switch panes without the prefix key.
- Allows Shift+Alt+H/L to switch to the previous/next window.
- Enables mouse support.

## TODO

- [ ] Install Homebrew on MacOS if not installed.
- [ ] Automatically pull latest changes to this repository before any setup.
- [ ] Add feature to restore original configuration from backed up dotfiles.
- [ ] Back up Vim configurations.
- [ ] Switch to NeoVim.
- [ ] Add support for fzf.
- [ ] Add support for VSCode configurations.
- [ ] Automatically download nerd fonts for tmux catppuccin.
