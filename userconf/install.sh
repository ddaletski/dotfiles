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

    path=$(readlink -f $3)

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
        current=`readlink -f $entry`
        parent=`readlink -f $(dirname $entry)`

        if [ $current = $parent ] ; then
            echo `colored blue found loop $entry and $(dirname $entry)`
            rm $entry
        else
            find_loops $entry
        fi
    done
}


echo `colored yellow cleaning symlink loops`
find_loops files 
echo `colored green done`

echo `colored yellow linking`
link_recursively `readlink -f files` $HOME files
echo `colored green done`
