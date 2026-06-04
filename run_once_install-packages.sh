#!/bin/bash

echo "🚀 Starting Arch Linux Environment Bootstrap..."

# 1. Check for an AUR Helper (paru or yay)
if ! command -v paru &> /dev/null && ! command -v yay &> /dev/null; then
    echo "📦 Installing paru as AUR helper..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/paru
else
    echo "✅ AUR helper already installed."
fi

# Set the helper variable
AUR_HELPER=$(command -v paru || command -v yay)

# 2. Install Core System & GUI Packages
echo "📥 Installing core packages..."
$AUR_HELPER -S --needed --noconfirm \
    hyprland hyprpaper hyprlock hypridle \
    waybar rofi-wayland kitty dolphin \
    uwsm eza zellij neovim \
    ttf-jetbrains-mono-nerd zathura zathura-pdf-mupdf \
    gnome-keyring nextcloud-client

# 3. Setup Multi-User Steam Group (From our earlier discussion)
if ! getent group steamusers > /dev/null; then
    echo "🎮 Creating steamusers group for shared library..."
    sudo groupadd steamusers
    sudo usermod -aG steamusers $USER
fi

# 4. Enable User Systemd Services
echo "⚙️ Enabling systemd user services..."
systemctl --user enable gnome-keyring.service
systemctl --user enable nextcloud-client.service
systemctl --user enable steam-pivot.service

echo "🎉 Bootstrap complete! Restart or run 'uwsm start default' to log in."
