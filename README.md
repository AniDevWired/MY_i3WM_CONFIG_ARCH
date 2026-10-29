# MY_i3WM_CONFIG_ARCH

This is my first i3wm ricing. I have added auto install script. I tried to keep the memory useage as low as possible bcuz I want to dailydrive my machine actually.

## :3

- i3-wm: Tiling Window Manager
- Alacritty: Terminal
- Rofi: Application Launcher
- Dunst: Notification Deamon

### Look and Feel

- **GTK theme:** `catppuccin-gtk-theme-mocha`
- **Icons:** Papirus-Dark with Catppuccin Mocha Lavender folders (`papirus-folders-catppuccin-git`)
- **Cursor:** Hatsune Miku cursors
- **Fonts:** JetBrains Mono Nerd Font, Font Awesome

## Requirements

- A working **Arch Linux** installation (or an Arch-based distro using `pacman`)
- An internet connection
- A regular user account with `sudo` access

## Installation

- Just download the install.sh script and run

```bash
chmod +x install.sh
sudo ./install.sh
```

> **Run it with `sudo` from your normal user account**, not from a root shell. The script uses `SUDO_USER` to work out whose home directory to install the configs into and to run AUR builds, since `makepkg` refuses to run as root.

### Warning: Existing Configs Are Overwritten

The script **deletes and replaces** these directories in `~/.config/`:

```
alacritty  gtk-3.0  i3  rofi  wallpaper  dunst  fastfetch
```

You will be asked to confirm before anything is changed. **Back up any configs you want to keep first.**

## What the Script Does

1. **Installs official packages** with `pacman` (i3, Alacritty, Rofi, Dunst, Thunar, Fastfetch, NetworkManager, fonts, and other dependencies)
2. **Enables services**: `NetworkManager` and `sysstat`
3. **Installs `yay`** (AUR helper) if it isn't already present
4. **Installs the theme** from the AUR: Catppuccin GTK Mocha, Papirus icons and Catppuccin Papirus folders, then applies the `cat-mocha-lavender` folder colour
5. **Installs the Hatsune Miku cursors** into `~/.local/share/icons`
6. **Copies the dotfiles** from this repo into `~/.config/`

## Troubleshooting

### xrandr
You might have to set your display configuration manually. If your screen is blank, blurry, or uses a different port than the default setup in `~/.config/i3/modules/autostart.conf`, follow these steps:

1. Find your correct display outputs by running:
   ```bash
   xrandr
   ```

2. Update the configuration line with your active display name, native resolution, and valid refresh rate:
   ```i3config
   exec --no-startup-id xrandr --output <YOUR_DISPLAY> --mode <YOUR_RES> --rate <YOUR_HZ> --primary
   ```

### rofi
The interface layout will break, distort, or completely hide lists on standard monitor resolutions due to the hardcoded `padding: 800px;` statement in `~/.config/rofi/custom-theme.rasi`. 

To fix the oversized window layout, replace the window block parameters using a cleaner, responsive approach:

```rasi
window {
    background-color: @bg-opaque;
    border:           2px;
    border-color:     @lavender;
    width:            550px;
    padding:          20px;
}
```

## After Installing

1. Log out.
2. At your display manager, choose the **i3** session and log in. If you start X from a TTY, make sure `exec i3` is in your `~/.xinitrc`.
3. If the GTK theme, icons or cursor don't apply automatically, open `lxappearance` and select:
   - **Widget:** Catppuccin Mocha
   - **Icon theme:** Papirus-Dark
   - **Cursor:** Miku cursor

## Credits

- [Catppuccin](https://github.com/catppuccin) for the colour palette and theme ports
- [Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
- [hatsune-miku-windows-linux-cursors](https://github.com/supermariofps/hatsune-miku-windows-linux-cursors) for the cursor set
