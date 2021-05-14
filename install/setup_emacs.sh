#!/usr/bin/env bash

function setup_emacs() {
    set -x

    echo "Copying \"init.el\" to $HOME/.emacs.d/"

    if [ ! -d "$HOME/.emacs.d" ]
    then
        echo "Making directory"
        mkdir $HOME/.emacs.d
    fi

    cp emacs.d/init.el $HOME/.emacs.d

    set +x
}
