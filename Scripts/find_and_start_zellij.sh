#!/bin/bash

# This script uses fzf to find a project directory and then
# opens or resurrects a Zellij session in the current terminal.
# Designed to be run directly from a terminal or via an alias.

# Configuration:
# Customize the base directories where the script searches for projects.
# Add more paths separated by spaces if needed.
PROJECT_DIRS="$HOME"

# Directories to ignore
IGNORED_DIR_NAMES=(
    ".git"
    ".eclipse"
    ".cargo"
    "node_modules"
    ".cache"
    "dist"
    "build"
    "target"
    "vendor"
    "__pycache__"
    ".idea"
    ".vscode"
    "tmp"
)

# --- Terminal cleanup trap ---
# This trap ensures that 'stty sane' is executed whenever the script exits,
# regardless of whether it exits normally, is cancelled (Ctrl+C), or encounters an error.
trap 'stty sane; echo "Terminal state restored." > /dev/tty' EXIT
# ---------------------------------

# Function to find directories using fzf
select_directory() {
    local find_cmd="find $PROJECT_DIRS -mindepth 1 -maxdepth 3 -type d"

    for dir_name in "${IGNORED_DIR_NAMES[@]}"; do
        find_cmd+=" -not -path \"*/$dir_name/*\" -not -name \"$dir_name\""
    done

    eval "$find_cmd 2>/dev/null" | sort | uniq | fzf \
        --height 40% \
        --layout=reverse \
        --border \
        --prompt="Select a project directory: " \
        --preview="ls -F {}" \
        --ansi \
        --pointer=">" \
        --marker="*" \
        --bind=ctrl-n:down \
        --bind=ctrl-p:up
}

# --- Main Logic ---

# Get the selected directory from fzf
SELECTED_DIR=$(select_directory)

# If nothing was selected (user pressed Escape or closed fzf), exit gracefully.
if [ -z "$SELECTED_DIR" ]; then
    echo "No directory selected. Exiting."
    exit 0
fi

# Basic validation: ensure the selected directory exists and is a directory
if [ ! -d "$SELECTED_DIR" ]; then
    echo "Error: '$SELECTED_DIR' is not a valid directory or does not exist." >&2
    exit 1
fi

# --- SESSION NAME GENERATION LOGIC (Folder + Parent Directory) ---
# Get the base name of the selected directory (e.g., "nvim")
BASE_DIR_NAME=$(basename "$SELECTED_DIR")

# Get the name of the parent directory (e.g., ".config" for /home/user/.config/nvim)
PARENT_DIR=$(dirname "$SELECTED_DIR")
PARENT_DIR_NAME=$(basename "$PARENT_DIR")

# Combine parent and base names, sanitizing for Zellij session names.
# Logic: If the parent is the user's home directory or the root, just use the base name.
# Otherwise, combine parent_name_base_name. This prevents generic names like "user_myproject".
if [ "$PARENT_DIR" = "$HOME" ] || [ "$PARENT_DIR" = "/" ] || [ -z "$PARENT_DIR_NAME" ]; then
    COMBINED_NAME="$BASE_DIR_NAME"
else
    COMBINED_NAME="${PARENT_DIR_NAME}_${BASE_DIR_NAME}"
fi

# Sanitize the combined name for a valid Zellij session name
# Replaces non-alphanumeric (including '.' and '/') with underscores, converts to lowercase,
# and removes any leading/trailing underscores.
SESSION_NAME=$(echo "$COMBINED_NAME" | sed 's/[^a-zA-Z0-9]/_/g' | tr '[:upper:]' '[:lower:]' | sed 's/^_//' | sed 's/_$//')

# Fallback for empty or problematic session names (e.g., if sanitization resulted in nothing)
if [ -z "$SESSION_NAME" ]; then
    SESSION_NAME=$(echo "$SELECTED_DIR" | md5sum | head -c 8)
fi
# --- END SESSION NAME GENERATION LOGIC ---

echo "Selected directory: $SELECTED_DIR"
echo "Attempting to attach/create Zellij session: $SESSION_NAME"

# Change to the selected directory before launching Zellij
cd "$SELECTED_DIR" || { echo "Failed to change directory to $SELECTED_DIR"; exit 1; }

# Attach to an existing Zellij session or create a new one
if zellij list-sessions | grep -q "$SESSION_NAME"; then
    echo "Session '$SESSION_NAME' already exists. Attaching..."
    zellij attach "$SESSION_NAME"
else
    echo "Session '$SESSION_NAME' does not exist. Creating new session..."
    zellij attach --create "$SESSION_NAME"
fi
