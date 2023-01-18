# Set Custom Resolutions (using `xrandr`)
This tool helps users set custom resolutions to monitors that aren't available by default (using `xrandr`).
>NOTE: This script only works on X11
# Example usage:
```bash
# This sets a custom resolution to HDMI-1
~$ setcustomres 1920 1080 HDMI-1
# This sets a custom resolution to DP-1 and maps it to the right of VGA-1
~$ setcustomres 1366 768 DP-1 "--right-of VGA-1"
# This sets a custom resolution to VGA-2 and makes it the primary screen
~$ setcustomres 1680 1050 VGA-2 "--primary"
```
# Installation:
```bash
# Clone github repository
git clone https://www.github.com/YoungFellow-le/setcustomres.git

# Install
cd setcustomres
chmod u+x setup.sh
sudo ./setup.sh install

# Uninstall
sudo ./setup.sh uninstall
```
## On Arch based distros:
You may install `setcustomres` from the AUR:
```bash
# Using 'yay'

yay -S setcustomres

# Using 'pamac'

pamac install setcustomres

# Manually

git clone https://aur.archlinux.org/setcustomres.git
cd setcustomres
makepkg PKGBUILD
```