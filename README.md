# an.sh - Dotfiles & Development Environment

**Author**: Ansh ([@mrdebator](https://github.com/mrdebator))
**Website**: [anshc.me](https://anshc.me)
**Last Updated**: March 2026

> A professor once joked that my name is technically the 'an' shell, hence the repository name.

This repository contains my dotfiles and automated setup scripts. The environment uses Neovim, Tmux, Zsh, and Alacritty, and is configured for systems programming, debugging, and AI-assisted development.

## Features

* **GNU Stow Architecture:** Configuration files are organized into packages and symlinked via GNU Stow. Supports `--personal` and `--work` profiles.
* **Zsh Environment:** Uses the `gitstatus` daemon to parse Git repositories asynchronously. Includes support for an untracked `~/.zshrc.local` file for machine-specific aliases and environment variables without causing merge conflicts.
* **Neovim (lazy.nvim):**
  * Auto-installs LSPs, formatters, and debug adapters via Mason.
  * Lazy-loaded Treesitter parsing to optimize startup time and avoid race conditions.
  * Debug Adapter Protocol (DAP) integration for Go (`delve`) and C/C++/Rust (`codelldb`) with automatic `.vscode/launch.json` discovery.
  * Git merge conflict resolution via `diffview.nvim`.
* **Tmux & Terminal:** Catppuccin Mocha theme applied consistently across Tmux, Alacritty, and the Neovim UI.
* **AI Integration:** Automated setup for the Gemini CLI. On personal Linux environments, the CLI is securely sandboxed using gVisor (`runsc`).

## Limitations

* **Platform Constraints:** Certain installation tasks (e.g., Google Chrome, Docker) are only fully implemented for macOS (via Homebrew) and Fedora (via DNF). Other Linux distributions may fallback to AppImages or require manual installation.
* **Gemini Sandboxing:** The gVisor (`runsc`) security sandbox for the Gemini CLI is only conditionally configured for Linux systems under the `--personal` profile.

## Prerequisites

* Unix-based OS (macOS, Fedora/RHEL, Debian/Ubuntu)
* Git
* A Nerd Font (e.g., JetBrainsMono Nerd Font)
* `gcc` (installed automatically on Linux)

## Installation

### Automated Setup

The `setup.sh` script installs dependencies and configures the environment based on the specified profile.

```bash
git clone https://github.com/mrdebator/an.sh.git ~/an.sh
cd ~/an.sh

# Install default profile (--personal)
./setup.sh --personal
```

To install or update a specific component without running the entire suite:

```bash
./setup.sh --target nvim
./setup.sh --target zsh
./setup.sh --target gemini
```

### Manual Installation

To bypass the setup script, ensure `stow` is installed and run:

```bash
cd ~/an.sh
stow alacritty nvim tmux zsh
stow -t ~/.oh-my-zsh oh-my-zsh
```

## Essential Key Bindings

| Context | Key | Action |
| --- | --- | --- |
| **Neovim (Core)** | `Space ff` / `fg` | Find files / Live grep (Telescope) |
|  | `gd` / `K` | Go to definition / Hover docs (LSP) |
|  | `Space e` | Toggle Neo-tree explorer |
| **Neovim (Git)** | `Space gm` | Open 3-way Merge Editor (Diffview) |
|  | `:diffg 1` / `3` | Accept "Ours" (Left) / "Theirs" (Right) |
| **Neovim (Debug)** | `Space db` / `dc` | Toggle Breakpoint / Launch Debugger |
|  | `Space dj/k/o` | Step Over / Step Into / Step Out |
|  | `Space dr` / `dq` | Open REPL / Terminate Session |
| **Tmux** | `Ctrl+a |` / `-` | Vertical / Horizontal split pane |
|  | `Alt+←→↑↓` | Navigate panes (No prefix) |

## Maintenance

To update your environment to the latest commits:

```bash
cd ~/an.sh
git pull --rebase
./setup.sh --target all
```

*Note: Neovim plugins are locked via `lazy-lock.json` to ensure reproducible environments. Update them from within Neovim using `:Lazy update`.*

## License

This project is licensed under the MIT License - see the [LICENSE]() file for details.