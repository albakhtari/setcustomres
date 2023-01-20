# Set Custom Resolutions (using `xrandr`)
This tool helps users set custom resolutions to monitors that aren't available by default (using `xrandr`).
>NOTE: This script only works on X11
# Example usage:
```bash
# This sets a custom resolution to HDMI-1
~$ setcustomres -w 1920 -h 1080 -o HDMI-1

# This sets a custom resolution to DP-1 and maps it to the right of VGA-1
~$ setcustomres --width 1366 --height 768 --output DP-1 --param "--right-of VGA-1"

# This sets a custom resolution to VGA-2 and makes it the primary screen
~$ setcustomres -w 1680 -h 1050 -o VGA-2 -p "--primary"
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
# Screenshot:
![image](https://user-images.githubusercontent.com/79008923/213722911-eb64cbb4-837d-4a97-983f-ae85d0ea18fb.png)
