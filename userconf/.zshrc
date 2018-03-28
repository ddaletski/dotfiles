# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored #_correct
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/denis/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob nomatch
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

PROMPT='%F{red}%n%f@%F{blue}%m%f %F{yellow}%1~%f %# '
cd ~


if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


export PATH=/home/denis/miniconda3/bin:$PATH:/home/denis/.gem/ruby/2.5.0/bin
export EDITOR=/usr/bin/nvim

remove_from_path() {
        export PATH=$(echo $PATH | awk -v RS=: -v ORS=: "/$1/{next}{print}")
}

act_conda() {
        remove_from_path "miniconda"
        export PATH="/home/denis/miniconda3/bin:$PATH"
}

deact_conda() {
        remove_from_path "miniconda"
}
