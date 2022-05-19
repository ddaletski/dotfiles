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

for files_dir in `find files -maxdepth 1 -mindepth 1 -type d`
do
    echo `colored blue installing $files_dir configs`

    echo `colored yellow cleaning symlink loops`
    find_loops $files_dir

    echo `colored yellow linking`
    link_recursively `$READLINK -f $files_dir` $HOME $files_dir

    echo `colored green done`
done

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
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install --lts

# rustup, cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh
bash /tmp/rustup.sh -y
cargo install du-dust

# go

if [ ! -d $HOME/.local/go ]
then
    case "$OSTYPE" in
      darwin*) wget -O /tmp/go.tar.gz https://golang.org/dl/go1.15.7.darwin-amd64.tar.gz ;;
      linux*) wget -O /tmp/go.tar.gz https://golang.org/dl/go1.15.7.linux-amd64.tar.gz ;;
    esac
    tar -C $HOME/.local -xzf /tmp/go.tar.gz
fi


# systemd user configs
mkdir -p $HOME/.config/systemd/user

if [ -x "$(command -v ngrok)" ]
then
    export NGROK_EXEC=$(which ngrok)
    cat templates/ngrok-ssh.service | envsubst > $HOME/.config/systemd/user/ngrok-ssh.service
    systemctl --user daemon-reload
    systemctl --user enable --now ngrok-ssh.service
fi
