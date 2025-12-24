#!/bin/bash

# This finds the real user's name even if run with sudo
# If run with sudo, $SUDO_USER
# If run without, it uses $USER
REAL_USER=${SUDO_USER:-$USER}

# This finds that user's actual home directory from the system
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

SHARED_APPS="/mnt/games/SteamLibrary/steamapps"
LOCAL_COMPAT="$REAL_HOME/.steam/steam/steamapps/compatdata"

# 1. Create the folder if it doesn't exist
mkdir -p "$LOCAL_COMPAT"

# 2. Wipe the old link
rm -rf "$SHARED_APPS/compatdata"

# 3. Create the new link
ln -s "$LOCAL_COMPAT" "$SHARED_APPS/compatdata"

# 4. Fix ownership  
chown -h "$REAL_USER:$REAL_USER" "$SHARED_APPS/compatdata"
chown -R "$REAL_USER:$REAL_USER" "$LOCAL_COMPAT"
