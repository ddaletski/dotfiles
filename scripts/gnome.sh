#!/bin/bash

# extensions installer
if [ ! -x "$(command -v gnome-shell-extension-installer)" ]; then
    wget -O /tmp/gnome-shell-extension-installer "https://github.com/ddaletski/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
    chmod +x /tmp/gnome-shell-extension-installer

    mkdir -p ~/.local/bin
    mv /tmp/gnome-shell-extension-installer ~/.local/bin/
fi

# install and enable some extensions
gnome-extensions info ddterm@amezin.github.com &> /dev/null
if [ $? != 0 ]; then
    gnome-shell-extension-installer 3780 --yes # ddterm
fi
gnome-extensions enable ddterm@amezin.github.com

gnome-extensions info clipboard-indicator@tudmotu.com &> /dev/null
if [ $? != 0 ]; then
    gnome-shell-extension-installer 2182 --yes # noannoyance v2
fi
gnome-extensions enable clipboard-indicator@tudmotu.com

gnome-extensions info noannoyance@daase.net &> /dev/null
if [ $? != 0 ]; then
    gnome-shell-extension-installer 779 --yes # clipboard indicator
fi
gnome-extensions enable noannoyance@daase.net


# settings for drop-down terminal
dconf write /com/github/amezin/ddterm/audible-bell false
dconf write /com/github/amezin/ddterm/background-opacity 0.95
dconf write /com/github/amezin/ddterm/custom-command "'tmux new-session -A -s tilda'"
dconf write /com/github/amezin/ddterm/custom-font "'NotoSansMono Nerd Font 13'"
dconf write /com/github/amezin/ddterm/ddterm-toggle-hotkey "['<Alt>grave']"
dconf write /com/github/amezin/ddterm/hide-animation-duration 0.1
dconf write /com/github/amezin/ddterm/palette "['rgb(0x17, 0x14, 0x21)', 'rgb(0xc0, 0x1c, 0x28)', 'rgb(0x26, 0xa2, 0x69)', 'rgb(0xa2, 0x73, 0x4c)', 'rgb(0x12, 0x48, 0x8b)', 'rgb(0xa3, 0x47, 0xba)', 'rgb(0x2a, 0xa1, 0xb3)', 'rgb(0xd0, 0xcf, 0xcc)', 'rgb(0x5e, 0x5c, 0x64)', 'rgb(0xf6, 0x61, 0x51)', 'rgb(0x33, 0xd1, 0x7a)', 'rgb(0xe9, 0xad, 0x0c)', 'rgb(0x2a, 0x7b, 0xde)', 'rgb(0xc0, 0x61, 0xcb)', 'rgb(0x33, 0xc7, 0xde)', 'rgb(0xff, 0xff, 0xff)']"
dconf write /com/github/amezin/ddterm/panel-icon-type "'toggle-button'"
dconf write /com/github/amezin/ddterm/pointer-autohide true
dconf write /com/github/amezin/ddterm/show-animation "'ease-out-cubic'"
dconf write /com/github/amezin/ddterm/show-animation-duration 0.07
dconf write /com/github/amezin/ddterm/use-theme-colors false
dconf write /com/github/amezin/ddterm/window-size 1.0


