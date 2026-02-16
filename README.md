# an.sh - My Dotfiles \& Personal Development Environment

**Author**: Ansh ([@mrdebator](https://github.com/mrdebator))
**Website**: [anshc.me](https://anshc.me)
**Last Updated**: February 2026

> A professor once made the 'dad' joke that my name is technically the 'an' shell, hence the repository name.

A comprehensive, modular dotfiles repository tailored for systems programming and security engineering. It features a modern, terminal-based development environment built around Neovim, Tmux, Zsh, and Alacritty—optimized for monolithic repositories, low-level debugging, and zero-latency execution.

## 🚀 Key Features

* 📦 **Modular GNU Stow Architecture:** Dotfiles are cleanly compartmentalized into packages and symlinked via GNU Stow. Installation is idempotent and profile-driven (`--personal` vs `--work`).
* 🚄 **Asynchronous Git Prompt:** The custom Zsh theme uses the `gitstatus` C++ daemon. It parses massive monolithic repositories in the background without ever freezing the terminal.
* 🐛 **Hermetic Debugging (DAP):** Full UI debugger integration for Go (`delve`) and C/Rust (`codelldb`), featuring inline virtual text, stack inspection, and REPL evaluation.
* 🔀 **Visual Merge Editor:** A VSCode-style 3-way split screen for resolving Git conflicts via `diffview.nvim`.
* ✨ **Unified Aesthetic:** Catppuccin Mocha theme applied consistently across Alacritty, Tmux, Neovim, and the terminal prompt.

## 🛠️ Installation

### Prerequisites

* Unix-based OS (macOS, Fedora/RHEL, Debian/Ubuntu)
* Git
* A Nerd Font (recommended: JetBrainsMono Nerd Font)

### The Setup Dispatcher

The repository uses a modular task dispatcher to install dependencies and stow configurations. It supports profile overrides for different machines.

```bash
# 1. Clone the repository
git clone https://github.com/mrdebator/an.sh.git ~/an.sh
cd ~/an.sh

# 2. Run the automated setup
# Options: --personal (default) or --work
./setup.sh --personal

```

**Surgical Updates:**
If you only want to install or update a specific component without running the full script, use the `--target` flag:

```bash
./setup.sh --target nvim
./setup.sh --target zsh
./setup.sh --target docker

```

### Manual Installation (GNU Stow)

If you prefer to bypass the setup script and link components manually, ensure `stow` is installed and run:

```bash
cd ~/an.sh
stow alacritty
stow nvim
stow tmux
stow zsh
stow -t ~/.oh-my-zsh oh-my-zsh

```

## Core Architecture

### Neovim (`lazy.nvim`)

* **LSP & Toolchain**: Mason (auto-installs LSPs, formatters, and debug adapters).
* **Fuzzy Finding**: Telescope (Files, Grep, Buffers, Git history).
* **Git UI**: `diffview.nvim` (Merge conflicts) + Fugitive + Gitsigns.
* **Debugging**: `nvim-dap` + `dap-ui` + `dap-virtual-text`.

### Tmux

* **Prefix**: Re-mapped to `Ctrl+a` for ergonomic access.
* **Splits**: `|` (Vertical) and `-` (Horizontal).
* **Navigation**: `Alt+Arrow` for panes, `Alt+H/L` for windows (No prefix required).

### Zsh (`oh-my-zsh`)

* **Theme**: Custom `mrdebator.zsh-theme` optimized for speed.
* **Plugins**: `gitstatus`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf`.

## ⌨️ Essential Key Bindings

| Context | Key | Action |
| --- | --- | --- |
| **Neovim (Core)** | `Space ff` / `fg` | Telescope: Find files / Live grep |
|  | `gd` / `K` | LSP: Go to definition / Hover docs |
|  | `Space e` | Toggle Neo-tree explorer |
| **Neovim (Git)** | `Space gm` | Open 3-way Merge Editor (Diffview) |
|  | `:diffg 1` / `3` | Accept "Ours" (Left) / "Theirs" (Right) |
| **Neovim (Debug)** | `Space db` / `dc` | Toggle Breakpoint / Launch Debugger |
|  | `Space dj/k/o` | Step Over / Step Into / Step Out |
|  | `Space dr` / `dq` | Open REPL / Terminate Session |
| **Tmux** | `Ctrl+a |` | Vertical split pane |
|  | `Alt+←→↑↓` | Navigate panes (No prefix) |

*For the complete list of 50+ keybindings, see the [suspicious link removed].*

## Maintenance

To update your environment to the latest commits and plugins:

```bash
cd ~/an.sh
git pull --rebase
./setup.sh --target all

```

*Note: Neovim plugins are locked via `lazy-lock.json` to ensure reproducible environments across machines. Update them from within Neovim using `:Lazy update`.*

## License

This project is licensed under the MIT License - see the [LICENSE]() file for details.
