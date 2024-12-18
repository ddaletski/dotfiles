. /etc/profile
. $HOME/.profile

fpath+=~/.zfunc

zmodload zsh/mathfunc

zstyle ':completion:*' completer _expand _complete _ignored #_correct
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' rehash true  # automatically find new executables in path zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle :compinstall filename '/$HOME/.zshrc'

autoload -Uz compinit
compinit

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt extendedglob nomatch
unsetopt nobeep
setopt histignorealldups  # If a new command is a duplicate, remove the older one
setopt nocaseglob # Case insensitive globbing
bindkey -v

PROMPT='%F{red}%n%f@%F{blue}%m%f %F{yellow}%1~%f %# '
cd ~

## Plugins section: Enable fish style features
# Use syntax highlighting
source $HOME/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Use history substring search
source $HOME/.local/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# search bindings
bindkey '^k' history-substring-search-up			
bindkey '^j' history-substring-search-down

cdl() {
    cd `readlink $1`
}

export EDITOR=vim

remove_from_path() {
    export PATH=$(echo $PATH | awk -v RS=: -v ORS=: "/$1/{next}{print}")
}

bbstatus() {
	cat /proc/acpi/bbswitch
}

bbswitchon() {
	echo "ON" | sudo tee /proc/acpi/bbswitch
}

bbswitchoff() {
	echo "OFF" | sudo tee /proc/acpi/bbswitch
}

check_mem() {
    pidof $1 | xargs -i cat /proc/{}/status | grep "RssAnon\|Threads"
}

display_local() {
  export DISPLAY=:0
}

display_wsl() {
  export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
  export LIBGL_ALWAYS_INDIRECT=1
}

display_remote() {
  export DISPLAY=localhost:10.0
}

brightness() {
  sudo modprobe i2c-dev
  sudo ddcutil setvcp 10 $1
}

icl() {
case "$OSTYPE" in
  darwin*)  pbcopy ;; 
  linux*)   xclip -sel clip -i ;;
esac
}

ocl() {
case "$OSTYPE" in
  darwin*)  pbpaste ;; 
  linux*)   xclip -sel clip -o ;;
esac
}

zf() {
    zip -r0 $1.zip $1
}

notify() {
    notify-send "$@" &> /dev/null & ; disown
    ffplay -autoexit -nodisp ~/.local/share/dotfiles-resources/notifications/done1.mp3 &> /dev/null & ; disown
}

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[45;93m' \
    LESS_TERMCAP_se=$'\e[0m' \
    command man "$@"
}

#########
# path

[ -d ~/.local/bin ] && export PATH=$PATH:$HOME/.local/bin
[ -d /home/linuxbrew/.linuxbrew/bin ] && export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
[ -d /opt/homebrew/bin ] && export PATH=$PATH:/opt/homebrew/bin
[ -d ~/.cargo ] && export PATH=$PATH:$HOME/.cargo/bin

#########
# homebrew completions
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$($HOME/miniconda3/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
