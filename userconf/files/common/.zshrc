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
zstyle :compinstall filename '/$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob nomatch
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

PROMPT='%F{red}%n%f@%F{blue}%m%f %F{yellow}%1~%f %# '
cd ~


case "$OSTYPE" in
  darwin*)  
	    alias ls='ls -G'
	    alias grep='grep --color=auto'
	    alias fgrep='fgrep --color=auto'
	    alias egrep='egrep --color=auto' ;;
  linux*)   
	if [ -x /usr/bin/dircolors ]; then
	    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	    alias ls='ls --color=auto'
	    #alias dir='dir --color=auto'
	    #alias vdir='vdir --color=auto'

	    alias grep='grep --color=auto'
	    alias fgrep='fgrep --color=auto'
	    alias egrep='egrep --color=auto'
        alias open='xdg-open'
	fi ;;
esac


# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


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

display_remote() {
  export DISPLAY=localhost:10.0
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
