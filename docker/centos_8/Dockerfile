FROM centos:8

ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN dnf update -y && \
        dnf install -y \
        gcc \
        gcc-c++ \
        make \
        git \
        wget \
        dnf-plugins-core

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf config-manager --set-enabled powertools

RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.2-linux-x86_64.tar.gz
RUN tar zxvf julia-1.6.2-linux-x86_64.tar.gz

RUN ln -s julia-1.6.2/bin/julia /usr/bin/julia

RUN dnf update -y

RUN useradd -ms /bin/bash org-user

USER org-user

WORKDIR /home/org-user/

ARG DEPLOYORG_VERSION=unknown
RUN git clone https://github.com/phrb/deploy-org.git

RUN dnf repolist

WORKDIR /home/org-user/deploy-org

# Requires sudo
USER root

# Install dependencies
RUN ./install/install.sh -i

# Does not require sudo
USER org-user

# Install Emacs configuration
RUN ./install/install.sh -e

# Test Emacs org exporter
RUN ./install/install.sh -t
