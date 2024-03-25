#!/bin/bash

SRC_DIR=$( dirname -- "$0"; )
source $SRC_DIR/scripts/common.sh

##########################################################
############# install needed software ####################

# brew
if [[ "$OSTYPE" == "darwin"* ]]; then
    colored blue installing homebrew
    if ! command_exists brew; then
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        mkdir -p ~/.zfunc
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' > ~/.zfunc/_brew
        eval "$(/opt/homebrew/bin/brew shellenv)"

        brew install coreutils
        export PATH=$PATH:/opt/homebrew/bin
    fi
fi


colored blue installing zsh plugins
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.local/share/zsh/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.local/share/zsh/plugins/zsh-syntax-highlighting

colored blue installing neovim plugin manager
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

colored blue installing resources
cp -r $SRC_DIR/resources $HOME/.local/share/dotfiles-resources

colored blue installing additional package managers

# nvm and nodejs
if ! command_exists node; then
    colored blue nvm
    curl -o - https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    nvm install node
fi

# rustup, cargo
if ! command_exists rustup; then
    colored blue rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh
    bash /tmp/rustup.sh -y
fi

# miniconda

bash $SRC_DIR/scripts/install_conda.sh

##########################################################
############### symlink configs ##########################

bash $SRC_DIR/scripts/link_configs.sh

###########################################################
############### resources #################################
colored blue installing resources

if [[ "$OSTYPE" == "darwin"* ]]; then
    cp $SRC_DIR/resources/fonts/* ~/Library/Fonts
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    mkdir -p ~/.local/share/fonts/
    cp $SRC_DIR/resources/fonts/* ~/.local/share/fonts
    fc-cache -f -v > /dev/null
fi
