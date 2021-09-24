#!/usr/bin/env bash

ERR_MSG="not supported yet"

OS_NAME=$(cat /etc/os-release | grep "^NAME=" | cut -d= -f2 | cut -d'"' -f2)
OS_VERSION=$(cat /etc/os-release | grep "^VERSION=" | cut -d= -f2 | cut -d'"' -f2)
OS_PRETTY=$(cat /etc/os-release | grep "^PRETTY_NAME=" | cut -d= -f2 | cut -d'"' -f2)

function os_installing() {
    echo "Installing on OS=[$OS_NAME] version=[$OS_VERSION]"
}

function os_err() {
    echo "OS=[$OS_NAME] version=[$OS_VERSION] $ERR_MSG"
    exit -1
}

function ubuntu_20043_lts() {
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
}

function ubuntu_2104() {
    ubuntu_20043_lts
}

function debian_109() {
    ubuntu_20043_lts
}

function debian_11() {
    ubuntu_20043_lts
}

function centos_8() {
    echo "Installing dependencies (requires sudo privileges)"
    dnf update -y
    dnf install -y \
        python2 \
        python39 \
        R \
        emacs \
        texlive \
        texlive-latex \
        texlive-xetex \
        texlive-luatex \
        latexmk
}

function check_os_eval() {
    case "$OS_NAME" in
        "Arch Linux")
            os_err
            ;;
        "CentOS Linux")
            case "$OS_VERSION" in
                "8")
                    os_installing
                    centos_8
                    ;;
                *)
                    os_err
                    ;;
            esac
            ;;
        "Ubuntu")
            case "$OS_VERSION" in
                "20.04.3 LTS (Focal Fossa)")
                    os_installing
                    ubuntu_20043_lts
                    ;;
                "21.04 (Hirsute Hippo)")
                    os_installing
                    ubuntu_2104
                    ;;
                *)
                    os_err
                    ;;
            esac
            ;;
        "Debian GNU/Linux")
            case "$OS_VERSION" in
                "10 (buster)")
                    os_installing
                    debian_109
                    ;;
                "11 (bullseye)")
                    os_installing
                    debian_11
                    ;;
                "")
                    case "$OS_PRETTY" in
                        "Debian GNU/Linux bullseye/sid")
                            os_installing
                            debian_11
                            ;;
                        *)
                            os_err
                            ;;
                    esac
                    ;;
                *)
                    os_err
                    ;;
            esac
            ;;
        *)
            os_err
            ;;
    esac
}
