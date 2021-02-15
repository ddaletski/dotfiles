# The following lines were added by compinstall
#
. /etc/profile
. $HOME/.profile

fpath+=~/.zfunc

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
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt extendedglob nomatch
unsetopt nobeep
setopt histignorealldups  # If a new command is a duplicate, remove the older one
setopt nocaseglob # Case insensitive globbing
bindkey -v
# End of lines configured by zsh-newuser-install

PROMPT='%F{red}%n%f@%F{blue}%m%f %F{yellow}%1~%f %# '
cd ~


case "$OSTYPE" in
  darwin*)  
	    alias grep='grep --color=auto'
	    alias fgrep='fgrep --color=auto'
	    alias egrep='egrep --color=auto' ;;
  linux*)   
	if [ -x /usr/bin/dircolors ]; then
	    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	    alias grep='grep --color=auto'
	    alias fgrep='fgrep --color=auto'
	    alias egrep='egrep --color=auto'
        alias open='xdg-open'
	fi ;;
esac


# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# utils overrides
alias find='fd'
alias grep='rg'

alias ls='exa'
alias ll='ls -alF'
alias l='ls --icons'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


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

export EDITOR=nvim

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
  xclip -sel clip -i
}

ocl() {
  xclip -sel clip -o
}

zf() {
    zip -r0 $1.zip $1
}

notify() {
    notify-send "$@" &> /dev/null & ; disown
    ffplay -autoexit -nodisp ~/.local/share/dotfiles-resources/notifications/done1.mp3 &> /dev/null & ; disown
}

# translator

ru2en() {
    echo $@ | parallel -n1 translate -s ru -d en '{}'
}

en2ru() {
    echo $@ | parallel -n1 translate -s en -d ru '{}'
}

ru2pl() {
    echo $@ | parallel -n1 translate -s ru -d pl '{}'
}

pl2ru() {
    echo $@ | parallel -n1 translate -s pl -d ru '{}'
}

ru2de() {
    echo $@ | parallel -n1 translate -s ru -d de '{}'
}

de2ru() {
    echo $@ | parallel -n1 translate -s de -d ru '{}'
}

ru2fr() {
    echo $@ | parallel -n1 translate -s ru -d fr '{}'
}

fr2ru() {
    echo $@ | parallel -n1 translate -s fr -d ru '{}'
}

#########
#
[ -d ~/.local/bin ] && export PATH=$PATH:$HOME/.local/bin

#########
# nvm

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -d ~/.cargo ] && export PATH=$PATH:$HOME/.cargo/bin
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


#########
# golang 

[ -d ~/.local/go/bin ] && export PATH=$PATH:$HOME/.local/go/bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/denis/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/denis/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/denis/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/denis/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
