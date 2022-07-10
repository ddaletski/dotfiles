case "$OSTYPE" in
  darwin*)  READLINK=greadlink ;; 
  linux*)   READLINK=readlink ;;
esac

colored() {
    case $1 in 
        'red')
            color='1;31' ;;
        'green')
            color='1;32' ;;
        'yellow')
            color='1;33' ;;
        'blue')
            color='1;34' ;;
        'purple')
            color='1;35' ;;
    esac

    echo -e "\033[${color}m${@:2}\033[m"
}

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


link_recursively() {
# $1 src dir
# $2 dest dir
# $3 current file or dir

    path=$($READLINK -f $3)

    if [ -d $path ] ; then
        entries=`find $path -maxdepth 1 -mindepth 1`
        for entry in $entries
        do 
            link_recursively $1 $2 $entry
        done
    elif [ -f $path ] ; then
        dest_file=${path/$1/$2}
        dest_dir=`dirname $dest_file`

        mkdir -p $dest_dir
        echo "$path -> $dest_file"
        ln -sf $path $dest_file
    fi
}


find_loops() {
    entries=`find $1 -maxdepth 1 -mindepth 1 -type d,l`

    for entry in $entries
    do
        current=`$READLINK -f $entry`
        parent=`$READLINK -f $(dirname $entry)`

        if [ $current = $parent ] ; then
            echo `colored blue found loop $entry and $(dirname $entry)`
            rm $entry
        else
            find_loops $entry
        fi
    done
}

##########################################################
############# install needed software ####################

echo `colored blue installing zsh plugins`
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.local/share/zsh/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.local/share/zsh/plugins/zsh-syntax-highlighting

echo `colored blue installing some apps`
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo `colored blue installing resources`
cp -r resources $HOME/.local/share/dotfiles-resources

echo `colored blue installing additional package managers`

# nvm and nodejs
echo `colored blue nvm`
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts

# rustup, cargo
echo `colored blue rustup`
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh
bash /tmp/rustup.sh -y
cargo install du-dust

##########################################################
############### symlink configs ##########################
for files_dir in `find files -maxdepth 1 -mindepth 1 -type d`
do
    echo `colored blue installing $files_dir configs`

    echo `colored yellow cleaning symlink loops`
    find_loops $files_dir

    echo `colored yellow linking`
    link_recursively `$READLINK -f $files_dir` $HOME $files_dir

    echo `colored green done`
done


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
