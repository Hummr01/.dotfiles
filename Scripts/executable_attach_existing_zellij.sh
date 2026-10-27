#!/bin/bash

# This script lists existing Zellij sessions and allows you to attach to one
# using fzf in the current terminal.
# Designed to be run directly from a terminal or via an alias.

# --- Terminal cleanup trap ---
# This ensures 'stty sane' is executed if the script is cancelled (Ctrl+C).
trap 'stty sane;' EXIT

# --- Function to list and select Zellij sessions using fzf ---
select_zellij_session() {
    # Get the list of Zellij sessions in short format, extract the name, and pipe to fzf.
    zellij list-sessions -s | awk '{print $1}' | grep -v "^$" | fzf \
        --height 40% \
        --layout=reverse \
        --border \
        --prompt="Attach Zellij Session: " \
        --ansi \
        --pointer=">" \
        --marker="*" \
        --bind=ctrl-n:down \
        --bind=ctrl-p:up
}

# --- Main Logic ---

# Get the selected session name from fzf
SELECTED_SESSION=$(select_zellij_session)

# If nothing was selected (user pressed Escape or closed fzf), exit gracefully.
if [ -z "$SELECTED_SESSION" ]; then
    echo "No session selected. Exiting."
    exit 0
fi

echo "Attempting to attach to Zellij session: $SELECTED_SESSION"

# Attach to the selected Zellij session in the current terminal.
zellij attach "$SELECTED_SESSION"
