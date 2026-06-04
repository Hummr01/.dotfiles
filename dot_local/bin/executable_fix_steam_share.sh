#!/bin/bash

# Steam Shared CompatData Pivot Script
# Runs as the active user to point the shared prefix folder to their home directory.

SHARED_APPS="/mnt/games/SteamLibrary/steamapps"
LOCAL_COMPAT="$HOME/.steam/steam/steamapps/compatdata"

# 1. Ensure the user's local compatdata folder exists
mkdir -p "$LOCAL_COMPAT"

# 2. Remove the existing symlink (left by the last user)
rm -rf "$SHARED_APPS/compatdata"

# 3. Create the new symlink pointing to THIS user's home
ln -s "$LOCAL_COMPAT" "$SHARED_APPS/compatdata"

echo "Steam shared compatdata linked to $USER"
