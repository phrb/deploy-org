#!/usr/bin/env bash

function setup_emacs() {
    set -x

    echo "Copying \"init.el\" to $HOME/.emacs.d/"

    if [ ! -d "$HOME/.emacs.d" ]
    then
        echo "Making directory"
        mkdir $HOME/.emacs.d
    elif [ -f "$HOME/.emacs.d/init.el" ]
    then
        echo "Backing up existing $HOME/.emacs/init.el"
        mv $HOME/.emacs.d/init.el $HOME/.emacs.d/backup.init.el
    fi

    cp emacs.d/init.el $HOME/.emacs.d

    set +x
}
