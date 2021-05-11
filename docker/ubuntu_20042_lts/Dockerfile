FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN useradd -ms /bin/bash org-user && \
        echo "org:org" | \
        chpasswd && adduser org-user sudo

USER org-user

WORKDIR /home/org-user/

RUN git clone https://github.com/phrb/deploy-org.git

WORKDIR /home/org-user/deploy-org

RUN ./install/install.sh
