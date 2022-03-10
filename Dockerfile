FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.15

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="tobbenb"

# install packages
RUN \
  echo "**** installing build deps ****" && \
  apk add --no-cache --upgrade \
    py3-pip \
    py3-setuptools && \
  echo "**** installing runtime deps ****" && \
  apk add --no-cache --upgrade \
    mosquitto \
    mosquitto-clients && \
  echo "**** adding abc to bluetooth group ****" && \
  usermod -a -G bluetooth abc && \
  echo "**** installing pyde1 ****" && \
  pip install pyDE1 && \
  pip list && \
  python -c \
    'import importlib.resources ; print(importlib.resources.files("pyDE1"))'



# copy local files
COPY root/ /

# ports and volumes
EXPOSE PORT
VOLUME /volume

## NOTES ##
## Delete files\folders not needed
## The User abc, should be running everything, give that permission in any case you need it.
## When creating init's Use 10's where posible, its to allow add stuff in between when needed. also, do not be afraid to split custom code into several little ones.
## user abc and folders /app /config /defaults are all created by baseimage
## the first available init script is 30<your script>
## you can comment the beginning of each new RUN block but you cannot comment between commands in each RUN block.
