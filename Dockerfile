# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.22

# set version label
ARG BUILD_DATE
ARG VERSION
ARG COOKLI_VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="tr4cks"

# set environment variables
ENV HOME="/recipes"

RUN \
  echo "**** install runtime packages ****" && \
  if [ -z ${COOKCLI_VERSION+x} ]; then \
    COOKCLI_VERSION=$(curl -sX GET "https://api.github.com/repos/cooklang/cookcli/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  export COMMIT_TAG="${COOKCLI_VERSION}" && \
  curl -o \
    /tmp/cookcli.tar.gz -L \
    "https://github.com/cooklang/cookcli/releases/download/${COOKCLI_VERSION}/cook-x86_64-unknown-linux-musl.tar.gz" && \
  tar xzf \
    /tmp/cookcli.tar.gz -C \
    /usr/local/bin/ && \
  chown root:root /usr/local/bin/cook && \
  chmod 755 /usr/local/bin/cook && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9080

VOLUME /recipes
