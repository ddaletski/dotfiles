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

# nvm and nodejs
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
nvm install --lts

# rustup, cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > .rustup.sh
bash .rustup.sh -y
cargo install sd du-dust exa ripgrep
