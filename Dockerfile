FROM ubuntu:12.04

RUN sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -yqq && \
    apt-get install -yqq gcc-4.6 libselinux-dev libpam-dev

CMD echo - | /usr/bin/gcc-4.6 -dM - -E -std=gnu99
