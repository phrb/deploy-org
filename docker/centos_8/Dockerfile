FROM centos:8

ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN dnf update -y && \
        dnf install -y \
        gcc \
        gcc-c++ \
        make \
        git \
        dnf-plugins-core

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf config-manager --add-repo https://copr.fedorainfracloud.org/coprs/nalimilan/julia/repo/epel-7/nalimilan-julia-epel-7.repo

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
