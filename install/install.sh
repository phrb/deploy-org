#!/usr/bin/env bash

set -e

function usage() {
    echo "Usage: $0 [OPTION]"
    echo -e "\t-i, --install\tInstall dependencies (requires sudo privileges)"
    echo -e "\t-e, --emacs\tCopy \"init.el\" to user home [$HOME/.emacs.d/]"
    echo -e "\t-t, --test\tTest user configuration [$HOME/.emacs.d/init.el]"
    echo -e "\t-h, --help\tPrint this message"
    exit 0
}

# http://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
if [ ${PWD##*/} != "deploy-org" ]
then
    echo "Running from $PWD"
    echo "Must run \"$0\" from repository root: deploy-org"
    exit -1
fi

if [ $# -eq 0 ]
then
    usage
    exit
fi

. setup_os.sh

. setup_emacs.sh

. tests.sh

while test $# -gt 0
do
    case "$1" in
        -i|--install)
            check_os_eval -i
            ;;
        -e|--emacs)
            setup_emacs
            ;;
        -t|--test)
            test_emacs
            ;;
        -h|--help|*)
            usage
            ;;
    esac
    shift
done
