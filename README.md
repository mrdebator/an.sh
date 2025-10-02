# an.sh - My Dotfiles \& Personal Development Environment

**Author**: Ansh ([@mrdebator](https://github.com/mrdebator))
**Website**: [anshc.me](https://anshc.me)
**Last Updated**: October 2025

> A professor once made the 'dad' joke that my name is technically the 'an' shell, hence the repository name.

A comprehensive dotfiles repository featuring a modern terminal-based development environment with NeoVim, Tmux, ZSH, and Alacritty configurations optimized for productivity and aesthetics.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-brightgreen.svg)
![Shell](https://img.shields.io/badge/shell-zsh-yellow.svg)
![Editor](https://img.shields.io/badge/editor-neovim-green.svg)

## 🚀 Features

### Development Environment

- **NeoVim**: Modern IDE experience with LSP, DAP, and custom keybindings
- **Tmux**: Session management with custom prefix and intuitive navigation
- **Alacritty**: GPU-accelerated terminal with Catppuccin theme
- **ZSH**: Custom theme with Git integration and smart auto-completion

### Key Highlights

- ✨ **Unified Aesthetic**: Catppuccin Mocha theme across all tools
- 🚄 **Fast**: Optimized prompt loading and minimal overhead
- 🔧 **LSP Integration**: Full IntelliSense for multiple languages
- 📁 **Smart File Navigation**: Telescope fuzzy finder and Neo-tree explorer
- 🎯 **Modal Editing**: Extensive Vim keybindings with modern enhancements
- 💾 **Auto-save**: Intelligent file saving on buffer switches
- 🔍 **Project Search**: Spectre for find & replace across files
- 🐛 **Debugging**: DAP integration for multiple languages

## 📸 Screenshots

```
┌─────────────────────────────────────────────────────┐
│ mrdebator@Computer ~/projects  main ✔               │
│  ─ ᐅ                                                │
│                                                      │
│ NeoVim with LSP, file explorer, and Git integration │
└─────────────────────────────────────────────────────┘
```

## 🛠️ Installation

### Prerequisites

- Unix-based OS (macOS, Linux, WSL2)
- Git
- Package manager (Homebrew for macOS, apt/yum/pacman for Linux)
- Nerd Font installed (recommended: JetBrainsMono Nerd Font)

### Quick Install

```bash
# Clone the repository
git clone https://github.com/mrdebator/an.sh.git ~/dotfiles
cd ~/dotfiles

# Run the setup script
./setup.sh
```

The setup script will:

1. Install required dependencies
2. Backup existing configurations
3. Create symbolic links to the dotfiles
4. Install plugin managers and plugins

### Manual Installation

If you prefer to install components separately:

```bash
# Symlink configurations
ln -sf ~/dotfiles/nvim/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/tmux/.config/tmux ~/.config/tmux
ln -sf ~/dotfiles/alacritty/.config/alacritty ~/.config/alacritty
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc

# Install Oh My Zsh and theme
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp ~/dotfiles/oh-my-zsh/custom/themes/mrdebator.zsh-theme ~/.oh-my-zsh/custom/themes/

# Install Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## 📦 Components

### NeoVim Configuration

- **Plugin Manager**: Lazy.nvim
- **File Explorer**: Neo-tree with icons
- **Fuzzy Finder**: Telescope
- **LSP Support**: Mason + native LSP
- **Syntax Highlighting**: Treesitter
- **Git Integration**: Fugitive, Gitsigns, Flog
- **Debugging**: nvim-dap with UI
- **Status Line**: Lualine with custom theme
- **Auto-completion**: nvim-cmp with snippets

### Tmux Configuration

- **Prefix Key**: `Ctrl+a` (remapped from `Ctrl+b`)
- **Intuitive Splits**: `|` for vertical, `-` for horizontal
- **Smart Navigation**: Alt+Arrow keys without prefix
- **Window Switching**: `Alt+H/L` for previous/next
- **Mouse Support**: Click to select panes, drag to resize
- **Theme**: Catppuccin Mocha

### ZSH Configuration

- **Framework**: Oh My Zsh
- **Custom Theme**: mrdebator (with Git status indicators)
- **Plugins**:
  - zsh-autosuggestions
  - zsh-completions
  - zsh-syntax-highlighting
  - fzf integration
- **Aliases**: Sensible defaults including `bat` for `cat`

### Alacritty Configuration

- **Theme**: Catppuccin Mocha
- **Font**: JetBrainsMono Nerd Font
- **Performance**: GPU acceleration enabled
- **Window**: Padding and opacity configured

## ⌨️ Key Bindings

### Essential Shortcuts

| Context      | Key         | Action               |
| ------------ | ----------- | -------------------- |
| **NeoVim**   | `Space`     | Leader key           |
|              | `Space ff`  | Find files           |
|              | `Space fg`  | Live grep            |
|              | `gd`        | Go to definition     |
|              | `K`         | Show documentation   |
| **Tmux**     | `Ctrl+a`    | Prefix key           |
|              | `Ctrl+a \|` | Vertical split       |
|              | `Ctrl+a -`  | Horizontal split     |
|              | `Alt+←→↑↓`  | Navigate panes       |
| **Terminal** | `Ctrl+r`    | Fuzzy history search |

Full keybinding reference available in [cheatsheet.md](cheatsheet.md)

## 📚 Documentation

- [Complete Cheatsheet](cheatsheet.md) - All keybindings and commands
- [Setup Guide](docs/setup.md) - Detailed installation instructions
- [Customization](docs/customization.md) - How to modify configurations

## 🤝 Contributing

Contributions are welcome! Feel free to:

- Report bugs
- Suggest new features
- Submit pull requests

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Catppuccin](https://github.com/catppuccin) for the beautiful theme
- [Oh My Zsh](https://ohmyz.sh/) for the ZSH framework
- [Lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management
- All the plugin authors who make this configuration possible

## 📊 Stats

- **Startup Time**: ~50ms (NeoVim)
- **Plugin Count**: 25+ carefully selected plugins
- **Languages Supported**: 15+ via LSP
- **Custom Keybindings**: 50+

## 🔄 Updates

This repository is actively maintained. To update:

```bash
cd ~/dotfiles
git pull
./setup.sh
```
