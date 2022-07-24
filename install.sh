#!bash

SRC_DIR=$( dirname -- "$0"; )
source $SRC_DIR/scripts/common.sh

##########################################################
############# install needed software ####################

# brew
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo `colored blue installing homebrew`
    if [ ! -x "$(command -v brew)" ]; then
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        mkdir -p ~/.zfunc
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' > ~/.zfunc/_brew
        eval "$(/opt/homebrew/bin/brew shellenv)"

        brew install coreutils
        export PATH=$PATH:/opt/homebrew/bin
    fi
fi


echo `colored blue installing zsh plugins`
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.local/share/zsh/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.local/share/zsh/plugins/zsh-syntax-highlighting

echo `colored blue installing some apps`
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo `colored blue installing resources`
cp -r $SRC_DIR/resources $HOME/.local/share/dotfiles-resources

echo `colored blue installing additional package managers`

# nvm and nodejs
echo `colored blue nvm`
curl -o - https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts

# rustup, cargo
echo `colored blue rustup`
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh
bash /tmp/rustup.sh -y

##########################################################
############### symlink configs ##########################

bash $SRC_DIR/scripts/link_configs.sh

##########################################################
############### other ####################################
echo `colored blue other utilities`

# systemd user configs
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
mkdir -p $HOME/.config/systemd/user
    if [ -x "$(command -v ngrok)" ]
    then
        export NGROK_EXEC=$(which ngrok)
        cat templates/ngrok-ssh.service | envsubst > $HOME/.config/systemd/user/ngrok-ssh.service
        systemctl --user daemon-reload
        systemctl --user enable --now ngrok-ssh.service
    fi
fi

###########################################################
############### resources #################################
echo `colored blue installing resources`

mkdir -p ~/.local/share/fonts/
cp $SRC_DIR/resources/fonts/* ~/.local/share/fonts
fc-cache -f -v > /dev/null
