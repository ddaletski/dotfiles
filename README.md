# dotfiles
My configuration files

## How it works
* all filetrees under `files/...` are symlinked recursively
* additional software is installed automatically

## Distribution contains configs for:
* neovim
* tmux
* zsh
* iterm2
* i3 desktop:
  * i3 config
  * i3status bar with fancy icons
  * conky
  * lightdm-gtk-greeter
  * icons, themes, cursors
* kde desktop configs:
  * plasma
  * yakuake and konsole
  * kate

## installation: 
```{bash} 
git clone https://github.com/ddaletski/dotfiles.git 
cd dotfiles
./install.sh
```  
