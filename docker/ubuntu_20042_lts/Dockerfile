FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        python3 \
        r-base \
        julia \
        git \
        emacs \
        texlive-latex-extra \
        texlive-xetex \
        texlive-luatex \
        latexmk

RUN useradd -ms /bin/bash org-user

USER org-user

WORKDIR /home/org-user/

RUN git clone https://github.com/phrb/deploy-org.git

WORKDIR /home/org-user/deploy-org

RUN ./install/ubuntu_20042_lts.sh
