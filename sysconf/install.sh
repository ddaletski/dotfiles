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


copy_recursively() {
    path=$(readlink -f $3)

    if [ -d $path ] ; then
        entries=`find $path -maxdepth 1 -mindepth 1`
        for entry in $entries
        do 
            copy_recursively $1 $2 $entry
        done
    elif [ -f $path ] ; then
        dest_file=${path/$1/$2}
        dest_dir=`dirname $dest_file`

        echo "$path ==> $dest_file"
        mkdir -p $dest_dir
        cp -i $path $dest_file
    fi
}


echo `colored yellow copying`
sudo bash -c "$(declare -f copy_recursively); copy_recursively $(readlink -f files) / files"
echo `colored green done`
