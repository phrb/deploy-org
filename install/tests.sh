#!/usr/bin/env bash

function test_emacs() {
    set -x

    echo "Running init.el loading tests"

    cd org/journal

    echo "Emacs version"
    emacs \
        --debug-init \
        --batch \
        --version

    echo "Loading init.el"
    emacs \
        --debug-init \
        --batch \
        --user $(whoami)

    echo "User Org version"
    emacs \
        --debug-init \
        --batch \
        --user $(whoami) \
        --eval="(org-version nil t t)"

    echo "Runing Emacs batch export of test org file"
    emacs \
        --debug-init \
        --batch \
        --user $(whoami) \
        journal.org \
        -f org-latex-export-to-pdf

    cd -

    set +x
}
