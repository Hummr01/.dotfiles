#!/bin/bash

# This is a master script to handle all Zellij-related Wofi interactions via Hyprland.
# It provides a toggle for Wofi menus and launches Zellij sessions.

# --- Configuration ---
# Configure your preferred terminal emulator here for new Zellij sessions
TERMINAL_CMD="kitty" # e.g., "kitty", "alacritty", "foot", "wezterm"
TERMINAL_ARGS="-e"   # e.g., "-e" for kitty/alacritty/foot, "start --" for wezterm

# For gnome-terminal, it's often:
# TERMINAL_CMD="gnome-terminal"
# TERMINAL_ARGS="-- /bin/bash -c"

# Wofi process name for toggling
WOFI_PROCESS_NAME="wofi"

# Base directories for project search (for 'projects' mode)
PROJECT_DIRS="$HOME" # Now set to search from your Home directory only.

# Directories to ignore during project search
IGNORED_DIR_NAMES=(
    ".git"
    "node_modules"
    ".cache"
    ".cargo"
    ".eclipse"
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
# This ensures 'stty sane' is executed whenever the script exits.
# Using '>&2' for echo directs output to stderr, keeping stdout clean for Wofi.
trap 'stty sane;' EXIT
# -----------------------------

# --- Helper Function: Generates Zellij Session Name ---
# Based on parent_directory_underscore_base_directory scheme
generate_zellij_session_name() {
    # Variables inside functions should use 'local'
    local selected_dir="$1"
    local base_dir_name=$(basename "$selected_dir")
    local parent_dir=$(dirname "$selected_dir")
    local parent_dir_name=$(basename "$parent_dir")
    local combined_name

    if [ "$parent_dir" = "$HOME" ] || [ "$parent_dir" = "/" ] || [ -z "$parent_dir_name" ]; then
        combined_name="$base_dir_name"
    else
        combined_name="${parent_dir_name}_${base_dir_name}"
    fi

    # Sanitize the combined name for a valid Zellij session name
    echo "$combined_name" | sed 's/[^a-zA-Z0-9]/_/g' | tr '[:upper:]' '[:lower:]' | sed 's/^_//' | sed 's/_$//'
}

# --- Main Logic ---

# Check for running Wofi instances for toggling
WOFI_PID=$(pgrep -x "$WOFI_PROCESS_NAME")

if [ -n "$WOFI_PID" ]; then
    # Wofi is running, kill all instances
    echo "Wofi found (PID: $WOFI_PID). Killing all Wofi instances." >&2
    kill "$WOFI_PID"
    exit 0 # Exit the script after killing Wofi
fi

# If Wofi is not running, proceed to launch the appropriate menu
# Removed 'local' from ZELLIJ_COMMAND
ZELLIJ_COMMAND="" # Initialize command to be executed in terminal

case "$1" in
    "projects")
        echo "Launching Zellij project finder..." >&2

        # --- Logic from original launch_zellij_dmenu.sh ---
        # Removed 'local' from find_cmd
        find_cmd="find $PROJECT_DIRS -mindepth 1 -maxdepth 3 -type d"
        for dir_name in "${IGNORED_DIR_NAMES[@]}"; do
            find_cmd+=" -not -path \"*/$dir_name/*\" -not -name \"$dir_name\""
        done

        # Removed 'local' from SELECTED_DIR
        SELECTED_DIR=$(eval "$find_cmd 2>/dev/null" | sort | uniq | wofi --show dmenu -p "Select Project: ")

        # Handle Wofi selection and prepare Zellij command
        if [ -z "$SELECTED_DIR" ]; then
            echo "No directory selected. Exiting." >&2
            exit 0
        fi

        if [ ! -d "$SELECTED_DIR" ]; then
            echo "Error: '$SELECTED_DIR' is not a valid directory or does not exist." >&2
            exit 1
        fi

        # Removed 'local' from SESSION_NAME
        SESSION_NAME=$(generate_zellij_session_name "$SELECTED_DIR")
        if [ -z "$SESSION_NAME" ]; then # Fallback for empty session name after sanitization
            SESSION_NAME=$(echo "$SELECTED_DIR" | md5sum | head -c 8)
        fi

        echo "Selected directory: $SELECTED_DIR" >&2
        echo "Attempting to attach/create Zellij session: $SESSION_NAME" >&2

        # Construct the command for the terminal
        ZELLIJ_COMMAND="cd \"$SELECTED_DIR\" || { echo \"Failed to change directory to $SELECTED_DIR\"; exit 1; } && "
        if zellij list-sessions | grep -q "$SESSION_NAME"; then
            ZELLIJ_COMMAND+="zellij attach \"$SESSION_NAME\""
        else
            ZELLIJ_COMMAND+="zellij attach --create \"$SESSION_NAME\""
        fi
        ;;

    "sessions")
        echo "Launching Zellij session attacher..." >&2

        # --- Logic from original attach_zellij_session.sh ---
        # Removed 'local' from SELECTED_SESSION
        SELECTED_SESSION=$(zellij list-sessions -s | awk '{print $1}' | grep -v "^$" | wofi --show dmenu -p "Attach Zellij Session: ")

        # Handle Wofi selection and prepare Zellij command
        if [ -z "$SELECTED_SESSION" ]; then
            echo "No session selected. Exiting." >&2
            exit 0
        fi

        echo "Attempting to attach to Zellij session: $SELECTED_SESSION" >&2
        ZELLIJ_COMMAND="zellij attach \"$SELECTED_SESSION\""
        ;;

    *)
        echo "Error: Invalid argument. Usage: $0 [projects|sessions]" >&2
        exit 1
        ;;
esac

# --- Launch the Terminal with the Zellij Command ---
# This part executes only if a valid ZELLIJ_COMMAND was constructed by the case statement.
if [ -n "$ZELLIJ_COMMAND" ]; then
    exec "$TERMINAL_CMD" "$TERMINAL_ARGS" bash -c "$ZELLIJ_COMMAND" & disown
else
    # This should ideally not be reached if previous 'exit 0' or 'exit 1' worked correctly
    echo "No Zellij command was constructed. Exiting." >&2
    exit 1
fi
