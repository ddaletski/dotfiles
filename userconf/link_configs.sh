#!bash

source ../common.sh

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
            echo `colored red found loop $entry and $(dirname $entry). Removing $entry`
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

