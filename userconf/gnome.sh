#!bash
wget -O /tmp/gnome-shell-extension-installer "https://github.com/ddaletski/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
chmod +x /tmp/gnome-shell-extension-installer
mv /tmp/gnome-shell-extension-installer ~/.local/bin/

gnome-shell-extension-installer 3780 --yes # ddterm
gnome-shell-extension-installer 2182 --yes # noannoyance v2
gnome-shell-extension-installer 779 --yes # clipboard indicator
