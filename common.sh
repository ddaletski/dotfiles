#!bash

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
