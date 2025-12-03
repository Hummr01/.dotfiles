#!/bin/bash
# run_once_yubikey-setup.sh

# Exit immediately if a command exits with a non-zero status
set -e

# NOTE: Chezmoi ensures ~/.ssh is created before running this script

YUBIKEY_KEY_FILE="$HOME/.ssh/id_ed25519_sk_rk"

# Check if the private key handle already exists
if [ ! -f "$YUBIKEY_KEY_FILE" ]; then
    echo "--- YubiKey SSH Key Setup ---"
    echo "Attempting to retrieve resident SSH key from YubiKey..."
    echo "Be ready to enter your FIDO2 PIN and touch the YubiKey."
    
    # ssh-keygen -K attempts to discover and save the resident key.
    # The -f flag specifies the output filename to match the one referenced in your config.
    ssh-keygen -K -f "$YUBIKEY_KEY_FILE"
    
    if [ $? -eq 0 ]; then
        echo "Success! YubiKey key handle saved as $YUBIKEY_KEY_FILE"
    else
        # Do NOT exit 1, as the user might not have the key inserted yet.
        echo "Warning: YubiKey key retrieval failed. Run 'ssh-keygen -K -f $YUBIKEY_KEY_FILE' manually later."
    fi
else
    echo "YubiKey key handle already exists. Skipping import."
fi
