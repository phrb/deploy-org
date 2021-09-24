FROM centos:8

ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN dnf update -y && \
        dnf install -y \
        gcc \
        gcc-c++ \
        make \
        git

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
