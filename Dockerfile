FROM ghcr.io/linuxserver/baseimage-alpine:3.15

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="tobbenb"

# environment settings
ENV \
  PIPFLAGS="--no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine/"

# install packages
RUN \
  echo "**** installing build deps ****" && \
  apk add --no-cache --upgrade \
    py3-pip \
    py3-setuptools \
    py3-wheel && \
  echo "**** installing runtime deps ****" && \
  apk add --no-cache --upgrade \
    bluez \
    dbus \
  && echo "**** adding abc to bluetooth group ****" \
  && usermod -a -G lp abc && \
  echo "**** installing pyde1 ****" && \
  pip install ${PIPFLAGS} \
    pyDE1 && \
  /usr/bin/python3 -c \
    'import importlib.resources ; print(importlib.resources.files("pyDE1"))' 

# copy local files
COPY root/etc /etc

# ports and volumes
#EXPOSE 80 443
