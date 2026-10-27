## ⚙️ Hummr's Dotfiles

Welcome to my personal collection of dotfiles, managed by [chezmoi](https://www.chezmoi.io/). These configurations are templated to support multiple systems, primarily my **Desktop** (dual-monitor) and my **Notebook** (dynamic display setup).

### 🚀 Getting Started on a New System

Use this sequence to quickly initialize your configurations on a clean machine.

#### Prerequisites

You must have **chezmoi** installed on the system.

**For Arch-based systems (e.g., Manjaro, Arch):**
```bash
sudo pacman -S chezmoi
```
#### Initialization Command
Execute the following command, replacing hummr01/dotfiles with the path to this repository.
```bash
# 1. Initialize and clone the repo into the chezmoi source directory
chezmoi init hummr/.dotfiles

# 2. (Optional but recommended) Review the planned changes before applying
chezmoi apply --dry-run --verbose

# 3. Apply the configurations to your home directory
chezmoi apply
```
.

### 🔄 Updating Configurations

#### 1. Pulling Updates from GitHub
If you've updated your configs on another machine and pushed them to GitHub:

```bash
# Pull changes from GitHub and update chezmoi's source directory
chezmoi update
```

#### 2. Saving Local Changes (Committing)
If you've modified a tracked file (e.g., ~/.config/hypr/hyprland.conf) and want to commit the change:

```bash
# Add the modified file to chezmoi's source state
chezmoi add ~/.config/hypr/hyprland.conf

# Commit and push changes to GitHub (uses your system's git)
chezmoi cd # Change into the chezmoi source directory
git status
git add .
git commit -m "Descriptive commit message"
git push
exit # Exit the chezmoi source directory
```

---

### 🐚 Shell Aliases & Workflows (Zsh)

Configured in `~/.config/zsh/aliases.zsh` and `~/.config/zsh/keybinds.zsh`.

#### 🚀 Zellij Project & Session Workflows
| Alias | Command / Description |
| :--- | :--- |
| `dev [dir]` | Smart-launch or attach to a Zellij session (auto-detects `web`, `python`, `latex`, or default `ai-dev` layout) |
| `dev-web [dir]` | Start/attach Zellij session using the **Web** layout (Neovim + OpenCode + dev server/git) |
| `dev-py [dir]` | Start/attach Zellij session using the **Python** layout (auto-activates `.venv`) |
| `dev-tex [dir]` | Start/attach Zellij session using the **LaTeX** layout |
| `newproj [type] [name]` | Interactive project scaffolder (`web`, `python`, `latex`, `arduino`, `empty`) in `~/Projects` (or `~/Arduino`) |
| `s` | Fuzzy-find a directory and launch a Zellij session (`~/Scripts/find_and_start_zellij.sh`) |
| `f` | Fuzzy-find and attach to an existing Zellij session (`~/Scripts/attach_existing_zellij.sh`) |

#### 🛠️ Daily CLI & Navigation
| Alias | Command | Description |
| :--- | :--- | :--- |
| `v` / `vi` / `vim` | `nvim` | Launch Neovim |
| `gvim` | `nvim --listen ~/.cache/nvim/godot.pipe .` | Launch Neovim listening for Godot engine |
| `ls` | `eza --icons --git-ignore` | Modern `ls` with icons, respecting `.gitignore` |
| `la` | `eza --icons -a` | List all files (including hidden) with icons |
| `..` / `...` | `cd ..` / `cd ../..` | Quick parent directory navigation (`.2`, `.3`, `.4` go deeper) |
| `mkdir` | `mkdir -p` | Create parent directories automatically |
| `sudo` | `nocorrect sudo -E ` | Run `sudo` preserving environment variables |
| `ssh` | `kitten ssh` | Kitty terminal SSH wrapper (propagates terminfo) |

#### 🌿 Git & Config Quick-Edit
| Alias | Command / Description |
| :--- | :--- |
| `ga` / `gc` / `gb` | `git add` / `git commit` / `git branch` |
| `zedit` | Edit and reload `.zshrc` |
| `aedit` | Edit and reload `aliases.zsh` |
| `fedit` / `pedit` | Edit and reload `functions.zsh` / `private.zsh` |

#### ⌨️ Zsh Keybind
* **`Ctrl + y`**: Accept inline Zsh autosuggestion (`autosuggest-accept`).

---

### ⌨️ System & Application Shortcuts

#### 🪟 Hyprland (Window Manager)
Configured in `~/.config/hypr/keymaps.lua` (`SUPER` = Windows/Meta key).

| Shortcut | Action |
| :--- | :--- |
| `SUPER + Return` | Launch terminal (`kitty`) |
| `SUPER + R` | Toggle application launcher (`rofi`) |
| `SUPER + B` | Launch browser (`brave`) |
| `SUPER + E` | Launch file manager (`dolphin`) |
| `SUPER + S` | Open Rofi Zellij **Project** picker (`dmenu_zellij.sh projects`) |
| `SUPER + Z` | Open Rofi Zellij **Session** switcher (`dmenu_zellij.sh sessions`) |
| `SUPER + W` | Close active window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + V` | Toggle floating window |
| `SUPER + P` | Toggle pseudotiling |
| `SUPER + M` | Exit Hyprland session (`uwsm stop`) |
| `SUPER + h / j / k / l` | Move focus Left / Down / Up / Right |
| `SUPER + 1..9 / 0` | Switch to workspace 1–10 |
| `SUPER + SHIFT + 1..9 / 0` | Move active window to workspace 1–10 |
| `SUPER + SHIFT + S` | Move active window to special scratchpad workspace (`special:magic`) |
| `SUPER + Mouse Drag (L/R)` | Move (`LMB`) or Resize (`RMB`) window |
| `Print` | Select region screenshot to clipboard (`slurp` + `grim` + `wl-copy`) |
| `SUPER + Print` | Capture window screenshot (`hyprshot -m window`) |

#### 🧩 Zellij (Terminal Multiplexer)
Configured in `~/.config/zellij/config.kdl` with **non-overlapping `Alt` bindings** so `Ctrl` keys stay free for Neovim.

| Shortcut | Action |
| :--- | :--- |
| `Ctrl + h / j / k / l` | Seamless navigation between Neovim splits and Zellij panes |
| `Alt + h / l` (or `Left/Right`) | Move focus or switch tabs Left / Right |
| `Alt + j / k` (or `Down/Up`) | Move focus Down / Up |
| `Alt + n` | Open a new pane |
| `Alt + f` | Toggle floating panes |
| `Alt + 1..5` | Jump directly to Tab 1–5 |
| `Alt + =` / `Alt + -` | Increase / Decrease focused pane size |
| `Alt + p` | Enter **Pane** mode (`n` new, `d` down, `r` right, `x` close, `f` fullscreen, `z` frames) |
| `Alt + t` | Enter **Tab** mode (`n` new, `r` rename, `x` close, `b` break pane to tab, `s` sync) |
| `Alt + r` | Enter **Resize** mode (`h/j/k/l` to grow, `H/J/K/L` to shrink) |
| `Alt + m` | Enter **Move** mode (`h/j/k/l` or `n/p` to move panes) |
| `Alt + s` | Enter **Scroll & Search** mode (`s` search, `e` edit scrollback in `$EDITOR`, `d/u` half-page) |
| `Alt + o` | Enter **Session** mode (`d` detach, `w` session manager, `l` layout manager, `q` quit) |
| `Ctrl + g` | Toggle **Locked** mode (passes all keys directly to the active terminal app) |

#### 📝 Neovim (LazyVim + AI & LaTeX)
Configured in `~/.config/nvim/lua/` (`<leader>` is `Space`).

**General & Navigation**
| Shortcut | Mode | Action |
| :--- | :--- | :--- |
| `jj` | Insert | Exit Insert Mode (`<Esc>`) |
| `<Esc><Esc>` | Terminal | Exit Terminal Mode |
| `Ctrl + h / j / k / l` | Normal | Navigate across Neovim splits and Zellij panes (`zellij-nav.nvim`) |
| `<leader>q` | Normal | Open diagnostic Quickfix list |

**AI Coding — OpenCode (`sidekick.nvim`)**
| Shortcut | Mode | Action |
| :--- | :--- | :--- |
| `Ctrl + .` | All | Focus OpenCode CLI pane |
| `<leader>aa` / `<leader>ao` | Normal | Toggle OpenCode CLI |
| `<leader>at` | Normal / Visual | Send current context (`{this}`) to OpenCode |
| `<leader>af` | Normal | Send current file to OpenCode |
| `<leader>av` | Visual | Send visual selection to OpenCode |
| `<leader>ap` | Normal / Visual | Select a Sidekick prompt |
| `<leader>as` / `<leader>ad` | Normal | Select installed AI CLI / Detach CLI session |
| `Alt + a` | Snacks Picker | Send selected picker item(s) to OpenCode |

**Local AI Inline Completion — Ollama (`minuet-ai.nvim`)**
| Shortcut | Mode | Action |
| :--- | :--- | :--- |
| `Alt + y` | Insert | Accept full inline completion |
| `Alt + a` / `Alt + z` | Insert | Accept single line / N lines of completion |
| `Alt + ]` / `Alt + [` | Insert | Cycle next / previous completion suggestion |
| `Alt + e` | Insert | Dismiss inline completion |
| `<leader>am` | Normal | Toggle Ollama inline virtual text suggestions |
| `<leader>aM` | Normal | Switch local Ollama model preset (`llama3.1:8b`, `gemma4:12b`, `qwen2.5-coder:7b`) |

**LaTeX (`vimtex`)**
| Shortcut | Mode | Action |
| :--- | :--- | :--- |
| `<leader>ll` | Normal | Launch / toggle continuous compilation (`latexmk -xelatex`) |
| `<leader>lv` / `<leader>lf` | Normal | View PDF / Forward search in `zathura` |
| `<leader>ls` | Normal | Stop compilation |
| `<leader>lc` | Normal | Clean auxiliary build files |
| `<leader>lt` | Normal | Toggle main LaTeX file |
