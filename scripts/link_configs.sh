#!/bin/bash

SCRIPTS_DIR=$( dirname -- "$0"; )

source $SCRIPTS_DIR/common.sh

link_recursively() {
# $1 src dir
# $2 dest dir
# $3 current file or dir

    set -f; IFS=$'\n'

    path=$($READLINK -f $3)

    if [ -d $path ] ; then
        entries=$(find $path -maxdepth 1 -mindepth 1)
        for entry in $entries
        do 
            link_recursively $1 $2 $entry
        done
    elif [ -f $path ] ; then
        dest_file=${path/$1/$2}
        dest_dir=$(dirname $dest_file)

        mkdir -p $dest_dir
        echo "$path -> $dest_file"
        ln -sf $path $dest_file
    fi

    set +f; unset IFS
}


find_loops() {
    entries=$(find $1 -maxdepth 1 -mindepth 1 -type d,l)

    for entry in $entries
    do
        current=$($READLINK -f $entry)
        parent=$($READLINK -f $(dirname $entry))

        if [ $current = $parent ] ; then
            colored red found loop $entry and $(dirname $entry). Removing $entry
            rm $entry
        else
            find_loops $entry
        fi
    done
}

FILES_DIR=$($READLINK -f $SCRIPTS_DIR/../files)

for files_dir in $(find ${FILES_DIR} -maxdepth 1 -mindepth 1 -type d)
do
    colored blue installing $files_dir configs

    colored yellow cleaning symlink loops
    find_loops $files_dir

    colored yellow linking
    link_recursively $($READLINK -f $files_dir) $HOME $files_dir

    colored green done
done
