#!/usr/bin/env bash

set -e

function usage() {
    echo "Usage: $0 [OPTION]"
    echo -e "\t-i, --install\tInstall dependencies (requires sudo privileges)"
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

while test $# -gt 0
do
    case "$1" in
        -i|--install)
            echo "Installing dependencies (requires sudo privileges)"
            apt-get update
            apt-get install -y --no-install-recommends \
                    python \
                    python3 \
                    r-base \
                    julia \
                    emacs \
                    texlive-latex-extra \
                    texlive-science \
                    texlive-xetex \
                    texlive-luatex \
                    latexmk
            ;;
        -h|--help|*)
            usage
            ;;
    esac
    shift
done
