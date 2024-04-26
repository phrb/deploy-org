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

function debian_12_lts() {
    echo "Installing dependencies (requires sudo privileges)"
    apt-get update
    apt-get install -y --no-install-recommends \
            python3 \
            r-base \
            emacs \
            texlive-latex-extra \
            texlive-science \
            texlive-xetex \
            texlive-luatex \
            texlive-plain-generic \
            latexmk
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

function debian_12() {
    debian_12_lts
}

function centos_8() {
    echo "Installing dependencies (requires sudo privileges)"
    dnf install -y \
        dnf-plugins-core \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

    dnf config-manager --set-enabled powertools
    dnf update -y

    dnf install -y \
        wget \
        python2 \
        python39 \
        R \
        texlive \
        texlive-latex \
        texlive-xetex \
        texlive-luatex \
        latexmk \
        libpng-devel \
        libtiff-devel \
        gnutls \
        gtk2-devel \
        ncurses-devel \
        giflib-devel \
        libX11-devel \
        libXpm-devel

    wget https://ftp.gnu.org/pub/gnu/emacs/emacs-27.2.tar.gz
    tar -zxvf emacs-27.2.tar.gz
    cd emacs-27.2
    ./configure --with-jpeg=ifavailable
    make
    make install

    cd -

    wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.2-linux-x86_64.tar.gz
    tar zxvf julia-1.6.2-linux-x86_64.tar.gz
    ln -s julia-1.6.2/bin/julia /usr/bin/julia
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
		"12 (bookworm)")
                    os_installing
                    debian_12
                    ;;
                "")
                    case "$OS_PRETTY" in
                        "Debian GNU/Linux bullseye/sid")
                            os_installing
                            debian_11
                            ;;
                        "Debian GNU/Linux 12 (bookworm)")
                            os_installing
                            debian_12
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
