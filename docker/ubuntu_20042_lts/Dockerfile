FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        git \
        apt-transport-https \
        ca-certificates && \
        update-ca-certificates

RUN useradd -ms /bin/bash org-user

USER org-user

WORKDIR /home/org-user/

RUN git clone https://github.com/phrb/deploy-org.git

WORKDIR /home/org-user/deploy-org

USER root

# Requires sudo
RUN ./install/install.sh -i

USER org-user

# Install Emacs configuration
RUN ./install/install.sh -e

# Test Emacs org exporter
RUN ./install/install.sh -t
