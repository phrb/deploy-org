#! /usr/bin/bash

set -e

function usage() {
    echo "Usage: $0 [OPTION]"
    echo -e "\t-e, --emacs\tCopy \"init.el\" to user home [$HOME/.emacs.d/]"
    echo -e "\t-t, --test\tTest user configuration [$HOME/.emacs.d/init.el]"
    echo -e "\t-h, --help\tPrint this message"
    exit 0
}

# http://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
if [ ${PWD##*/} != "deploy-org" ]
   then
   echo -e "\tMust run \"$0\" from repository root: deploy-org"
   exit -1
fi

if [ $# -eq 0 ]
   then
   usage
   exit
fi

while test $# -gt 0
do
    case "$1" in
        -e|--emacs)
            echo "Copying \"init.el\" to $HOME/.emacs.d/"

            if [ ! -d "$HOME/.emacs.d" ]
            then
                echo "Making directory"
                mkdir $HOME/.emacs.d
            fi

            cp emacs.d/init.el

            ;;
        -t|--test)
            echo "Running pdf compilation test"
            ;;
        -h|--help|*)
            usage
            ;;
    esac
    shift
done
