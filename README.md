# Set Custom Resolution (using `xrandr`)
This tool helps users set custom resolutions to monitors that aren't there by default (using `xrandr`).
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

# Make file executable
cd setcustomres
chmod u+x setcustomres.sh

# Make command native (optional)
sudo ln -s $PWD/setcustomres.sh /usr/bin/setcustomres
```
## On Arch based distros:
You may install `setcustomres` from the AUR:
```
yay -S setcustomres
```