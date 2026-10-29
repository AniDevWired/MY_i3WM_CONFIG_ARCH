#!/usr/bin/env bash

#exit immediately if a command exits with a non-zero status
set -e

#root privilege enforcement
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script installs system packages and must be run with root privileges (sudo)."
    echo "Please re-run using: sudo $0"
    exit 1
fi

REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

#warning
echo "WARNING: OVERWRITE NOTICE!!!!!"
echo "This script will completely delete and overwrite existing"
echo "configurations inside: $REAL_HOME/.config/{i3, rofi, alacritty, gtk-3.0, dunst, fastfetch}"
echo ""
echo "If you have custom tweaks in those directories, back them up now."
read -p "Do you want to proceed and overwrite these dotfiles? (y/N): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Installation cancelled by user."
    exit 0
fi

echo "[*] Launching Legendry Arch Linux i3wm setup..."

#update stuffs
echo "[*] Updating package database & installing few dependencies..."
pacman -Syu --needed --noconfirm \
    base-devel git alacritty fastfetch thunar i3lock xorg-xrandr \
    networkmanager network-manager-applet polkit-gnome feh rofi \
    dunst libnotify ttf-jetbrains-mono-nerd otf-font-awesome \
    i3-wm gtk3 mpstat sysstat ddcutil lxappearance libarchive unzip gzip

#services
echo "[*] Enabling background services..."
systemctl enable --now NetworkManager.service
systemctl enable --now sysstat.service

#yay
if ! command -v yay &> /dev/null; then
    echo "[*] Installing 'yay' AUR helper..."
    mkdir -p /tmp/yay-build
    chown -R "$REAL_USER":"$REAL_USER" /tmp/yay-build
    
    runuser -u "$REAL_USER" -- bash -c "
        cd /tmp/yay-build
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
    "
else
    echo "[*] 'yay' helper already exists. Skipping..."
fi

#themes
echo "[*] Installing desktop themes and icons..."
runuser -u "$REAL_USER" -- yay -S --noconfirm catppuccin-gtk-theme-mocha papirus-icon-theme papirus-folders-catppuccin-git

#apply changes
runuser -u "$REAL_USER" -- papirus-folders -C cat-mocha-lavender --theme Papirus-Dark

echo "[*] Change your theme to catpucchin-mocha-lavender-standard+default from lxappearance manually"

#MIKU CURSOR!!!
echo "[*] Installing Hatsune Miku cursors..."
runuser -u "$REAL_USER" -- mkdir -p "$REAL_HOME/.local/share/icons"
mkdir -p /tmp/miku-build
chown -R "$REAL_USER":"$REAL_USER" /tmp/miku-build
runuser -u "$REAL_USER" -- bash -c "
    cd /tmp/miku-build
    git clone https://github.com/supermariofps/hatsune-miku-windows-linux-cursors.git
    cp -r hatsune-miku-windows-linux-cursors/miku-cursor-linux '$REAL_HOME/.local/share/icons/'
"

#refresh system fonts
fc-cache -fv

#dotfiles
echo "[*] Overwriting specified configurations in ~/.config/..."
mkdir -p /tmp/my-config-build
chown -R "$REAL_USER":"$REAL_USER" /tmp/my-config-build

runuser -u "$REAL_USER" -- bash -c "
    cd /tmp/my-config-build
    git clone https://github.com/AniDevWired/MY_i3WM_CONFIG_ARCH.git
    cd MY_i3WM_CONFIG_ARCH

    # Explicitly targeted directories to replace
    for dir in alacritty gtk-3.0 i3 rofi wallpaper dunst fastfetch; do
        if [ -d \"\$dir\" ]; then
            echo \"  -> Replacing existing \$dir configuration...\"
            rm -rf '$REAL_HOME/.config/'\"\$dir\"
            cp -r \"\$dir\" '$REAL_HOME/.config/'
        fi
    done
"

echo "[*] Finalizing configurations and starting system trays..."

runuser -u "$REAL_USER" -- bash -c "
    nm-applet --indicator &
    killall dunst || true
    dunst -config '$REAL_HOME/.config/dunst/dunstrc' &
    notify-send 'Setup Active' 'Target user configurations have been cleanly overwritten!'
"

rm -rf /tmp/yay-build /tmp/my-config-build /tmp/miku-build

echo "Done! System dependencies installed and configs overwritten."
