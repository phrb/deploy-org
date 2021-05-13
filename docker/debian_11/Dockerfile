FROM debian:bullseye

ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        build-essential \
        git \
        apt-transport-https \
        ca-certificates && \
        update-ca-certificates

RUN useradd -ms /bin/bash org-user

USER org-user

WORKDIR /home/org-user/

ARG DEPLOYORG_VERSION=unknown
RUN git clone https://github.com/phrb/deploy-org.git

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
