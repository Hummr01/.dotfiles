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
Execute the following command, replacing hummr/dotfiles with the path to this repository.
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
