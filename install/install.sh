#! /usr/bin/bash

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

ERR_MSG="not supported yet"

OS_NAME=$(cat /etc/os-release | grep "^NAME=" | cut -d= -f2 | cut -d'"' -f2)
OS_VERSION=$(cat /etc/os-release | grep "^VERSION=" | cut -d= -f2 | cut -d'"' -f2)

function check_os_eval() {
    case "$OS_NAME" in
        "Arch Linux")
            echo "$OS_NAME (rolling) $ERR_MSG"
            ;;
        "Ubuntu")
            case "$OS_VERSION" in
                "20.04.2 LTS (Focal Fossa)")
                    echo "Installing on $OS_NAME $OS_VERSION"
                    ./install/ubuntu_20042_lts.sh "$@"
                    ;;
                *)
                    echo "$OS_NAME $OS_VERSION $ERR_MSG"
                    ;;
            esac
            ;;
        *)
            echo "$OS_NAME $OS_VERSION $ERR_MSG"
            ;;
    esac
}

while test $# -gt 0
do
    case "$1" in
        -i|--install)
            check_os_eval -i
            ;;
        -e|--emacs)
            echo "Copying \"init.el\" to $HOME/.emacs.d/"

            if [ ! -d "$HOME/.emacs.d" ]
            then
                echo "Making directory"
                mkdir $HOME/.emacs.d
            fi

            cp emacs.d/init.el $HOME/.emacs.d
            ;;
        -t|--test)
            echo "Running pdf compilation test"

            cd org/journal

            echo "Starting Emacs daemon"
            emacs --debug-init --batch --user $USER

            echo "Runing Emacs batch export of test org file"
            emacs \
                --debug-init \
                --batch \
                --user $USER \
                journal.org \
                -f org-latex-export-to-pdf

            cd -
            ;;
        -h|--help|*)
            usage
            ;;
    esac
    shift
done
