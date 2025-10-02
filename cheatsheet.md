# Personal Development Environment Cheatsheet

## Tmux Commands

**Prefix Key:** `Ctrl+a` (changed from default `Ctrl+b`)

### Session Management

| **Key**               | **Action**          |
| --------------------- | ------------------- |
| `tmux`                | Start new session   |
| `tmux new -s name`    | Start named session |
| `tmux ls`             | List sessions       |
| `tmux attach -t name` | Attach to session   |
| `Ctrl+a d`            | Detach from session |
| `Ctrl+a $`            | Rename session      |

### Window Management

| **Key**      | **Action**                  |
| ------------ | --------------------------- |
| `Ctrl+a c`   | Create new window           |
| `Ctrl+a ,`   | Rename window               |
| `Ctrl+a &`   | Kill window                 |
| `Ctrl+a 1-9` | Switch to window number     |
| `Alt+H`      | Previous window (no prefix) |
| `Alt+L`      | Next window (no prefix)     |

### Pane Management

| **Key**          | **Action**           |
| ---------------- | -------------------- |
| `Ctrl+a \|`      | Split vertical       |
| `Ctrl+a -`       | Split horizontal     |
| `Ctrl+a x`       | Kill pane            |
| `Ctrl+a z`       | Toggle pane zoom     |
| `Ctrl+a {` / `}` | Move pane left/right |
| `Ctrl+a o`       | Cycle through panes  |
| `Ctrl+a q`       | Show pane numbers    |

### Pane Navigation

| **Key** | **Action**                    |
| ------- | ----------------------------- |
| `Alt+←` | Select left pane (no prefix)  |
| `Alt+→` | Select right pane (no prefix) |
| `Alt+↑` | Select upper pane (no prefix) |
| `Alt+↓` | Select lower pane (no prefix) |

### Other Features

| **Key**          | **Action**                           |
| ---------------- | ------------------------------------ |
| Mouse click/drag | Select panes/windows, resize, scroll |
| `Ctrl+a [`       | Enter copy mode                      |
| `Ctrl+a ]`       | Paste from buffer                    |

## NeoVim Commands

**Leader Key:** `<Space>` (spacebar)

### 1. Essential Modal Editing

#### Switching Modes

| **Key(s)**          | **Action**                  | **Mode** |
| ------------------- | --------------------------- | -------- |
| `i`                 | **I**nsert before cursor    | Insert   |
| `a`                 | **A**ppend after cursor     | Insert   |
| `I`                 | Insert at beginning of line | Insert   |
| `A`                 | Append at end of line       | Insert   |
| `o`                 | **O**pen line below         | Insert   |
| `O`                 | **O**pen line above         | Insert   |
| `v`                 | Character-wise **V**isual   | Visual   |
| `V`                 | Line-wise **V**isual        | Visual   |
| `Ctrl+v`            | Block-wise **V**isual       | Visual   |
| `<Esc>` or `Ctrl+[` | Return to Normal mode       | Normal   |

#### Navigation (Normal Mode)

| **Key**           | **Action**                             |
| ----------------- | -------------------------------------- |
| `h`/`l`           | Move left/right                        |
| `j`/`k`           | Move down/up (display lines with wrap) |
| `0`/`$`           | Start/end of line (wrapped line aware) |
| `^`               | First non-blank character              |
| `w`/`b`           | Next/previous word                     |
| `e`/`ge`          | Next/previous word end                 |
| `gg`/`G`          | First/last line                        |
| `{number}G`       | Go to line {number}                    |
| `Ctrl+d`/`Ctrl+u` | Half page down/up (centered)           |
| `H`               | Top of screen                          |
| `M`               | Middle of screen                       |
| `L`               | Bottom of screen                       |

#### Editing

The core idea is **`operator + motion`**. For example, `d` (delete) is an operator and `w` (word) is a motion. `dw` means "delete word".

##### Basic Editing

| **Operator** | **Action**         | **Example(s)**                                                             |
| ------------ | ------------------ | -------------------------------------------------------------------------- |
| `x`          | Delete character   |                                                                            |
| `d`          | **D**elete         | `dd` (delete line), `dw` (delete word), `d$` (delete to end of line)       |
| `c`          | **C**hange         | `cc` (change line), `cw` (change word) — _deletes and enters Insert mode._ |
| `y`          | **Y**ank (Copy)    | `yy` (yank line), `yw` (yank word)                                         |
| `p`          | **P**aste          | Paste after the cursor.                                                    |
| `P`          | **P**aste          | Paste before the cursor.                                                   |
| `u`          | **U**ndo           | Undo the last action.                                                      |
| `Ctrl+r`     | **R**edo           | Redo the last undone action.                                               |
| `.`          | Repeat last change |                                                                            |

##### Text Objects (Use with d, c, y, v)

| **Object**   | **Meaning**               | **Example**                     |
| ------------ | ------------------------- | ------------------------------- |
| `iw`         | Inside word               | `diw` = delete word             |
| `aw`         | Around word (with spaces) | `caw` = change word + spaces    |
| `i"`         | Inside quotes             | `ci"` = change inside quotes    |
| `a"`         | Around quotes             | `da"` = delete with quotes      |
| `i(` or `ib` | Inside parentheses        | `yi(` = yank inside parens      |
| `i{` or `iB` | Inside braces             | `di{` = delete inside braces    |
| `it`         | Inside tags               | `cit` = change inside HTML tags |

##### Search

| **Key**    | **Action**                          |
| ---------- | ----------------------------------- |
| `/pattern` | Search forward                      |
| `?pattern` | Search backward                     |
| `n`        | Next match (centered\*)             |
| `N`        | Previous match (centered\*)         |
| `*`        | Search word under cursor            |
| `#`        | Search word under cursor (backward) |

### 2. File & Project Navigation

#### Telescope (Fuzzy Finding)

| **Key**     | **Action**                 |
| ----------- | -------------------------- |
| `<Space>ff` | **F**ind **F**iles         |
| `<Space>fg` | **F**ind with **G**rep     |
| `<Space>fb` | **F**ind **B**uffers       |
| `<Space>fr` | **F**ind **R**ecent files  |
| `<Space>fs` | **F**ind **S**ymbols       |
| `<Space>fw` | Find **W**ord under cursor |
| `<Space>/`  | Search in current buffer   |

#### Neo-Tree

| **Key**    | **Action**           |
| ---------- | -------------------- |
| `<Space>e` | Toggle file explorer |

### 3. Window & Buffer Management

| **Key**             | **Action**           |
| ------------------- | -------------------- |
| `Ctrl+h/j/k/l`      | Navigate windows     |
| `<Tab>` / `<S-Tab>` | Next/previous buffer |
| `<Space>bd`         | Delete buffer        |
| `<Space>wq`         | Save and quit all    |
| `<Space>qq`         | Force quit all       |

### 4. Code Intelligence (LSP)

| **Key**     | **Action**                   |
| ----------- | ---------------------------- |
| `K`         | Show documentation           |
| `gd`        | **G**o to **D**efinition     |
| `gD`        | **G**o to **D**eclaration    |
| `gi`        | **G**o to **I**mplementation |
| `gr`        | **G**o to **R**eferences     |
| `<Space>rn` | **R**e**n**ame symbol        |
| `<Space>ca` | **C**ode **A**ctions         |
| `<Space>d`  | Show **d**iagnostics         |
| `[d`/`]d`   | Previous/next diagnostic     |
| `<Space>F`  | **F**ormat file              |

### 5. Git Integration

| **Key**     | **Action**               |
| ----------- | ------------------------ |
| `<Space>gg` | Git graph (Flog/LazyGit) |
| `<Space>gc` | Git commits              |
| `<Space>gb` | Git branches             |

### 6. Search & Replace

| **Key**         | **Action**                 |
| --------------- | -------------------------- |
| `<Space>sr`     | Search & Replace (Spectre) |
| `<Space>sw`     | Search word under cursor   |
| `/pattern`      | Search in file             |
| `:%s/old/new/g` | Replace all in file        |

### 7. Terminal

| **Key**     | **Action**                  |
| ----------- | --------------------------- |
| `<Space>tt` | Toggle terminal             |
| `<Space>tv` | Split terminal vertically   |
| `<Space>th` | Split terminal horizontally |

### 8. Debugging (DAP)

| **Key**         | **Action**         |
| --------------- | ------------------ |
| `<Space>dc`     | Continue           |
| `<Space>db`     | Toggle breakpoint  |
| `<Space>dj/k/o` | Step over/into/out |

## Common Workflows

### Session Management

1. `tmux new -s project` - Start project session
2. Work across multiple windows/panes
3. `Ctrl+a d` - Detach when done
4. `tmux attach -t project` - Resume later

### File Navigation

1. `Space ff` - Find files quickly
2. `Space fg` - Search project text
3. `Space e` - Browse file tree

### Code Editing Flow

1. `gd` - Jump to definition
2. Make changes
3. `Space F` - Format code
4. `Space ca` - Apply quick fixes
5. Files auto-save on buffer switch

### Multi-Pane Development

1. `Ctrl+a |` - Split for side-by-side files
2. `Alt+←/→` - Switch between panes
3. `Ctrl+a z` - Zoom pane for focus
4. `Space tt` - Toggle terminal in NeoVim

### Window Organization

```
Window 1: Main code (NeoVim)
Window 2: Tests (NeoVim)
Window 3: Terminal/logs
Window 4: Documentation
```

Switch with `Alt+H/L` or `Ctrl+a 1-4`

### Search & Replace Across Project

1. `Space sr` - Open Spectre
2. Enter search/replace patterns
3. Preview changes
4. Apply to all files

## Tips for Productivity

### Tmux Best Practices

- Name sessions by project: `tmux new -s api`
- Use windows for major contexts (code/test/docs)
- Use panes for related files
- Enable mouse for quick selection/resize

### NeoVim Efficiency

- Master text objects: `di(` faster than selecting
- Use counts: `3dd` deletes 3 lines
- Leverage dot repeat: `.`
- Let auto-save handle file writing

### Combined Power Moves

- Tmux for project organization
- NeoVim for code editing
- Terminal pane for git/commands
- Multiple windows for different concerns

### Quick Reference Card

**Most Used Daily:**

- **Tmux:** `Ctrl+a c` (new window), `Alt+H/L` (switch), `Ctrl+a |/-` (split)
- **Navigate:** `Space ff` (files), `gd` (definition), `K` (docs)
- **Edit:** `Space F` (format), `Space ca` (actions), `Space rn` (rename)
- **Git:** `Space gg` (LazyGit)

## Essential Commands

### Tmux Commands

```bash
tmux ls                    # List sessions
tmux kill-session -t name  # Kill session
tmux kill-server          # Kill all sessions
```

### NeoVim Commands

```vim
:Mason          # Manage LSP servers
:Lazy           # Manage plugins
:checkhealth    # Check setup
:wqa            # Save and quit all
```

### Shell Integration

- The custom ZSH theme shows git status
- Alacritty provides GPU acceleration
- Together: Fast, visual, productive environment
