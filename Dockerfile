# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.22

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CHEF_VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="tr4cks"

# set environment variables
ENV HOME="/recipes"

RUN \
  echo "**** install runtime packages ****" && \
  if [ -z ${CHEF_VERSION+x} ]; then \
    CHEF_VERSION=$(curl -sX GET "https://api.github.com/repos/Zheoni/cooklang-chef/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  export COMMIT_TAG="${CHEF_VERSION}" && \
  curl -o \
    /tmp/chef.tar.gz -L \
    "https://github.com/Zheoni/cooklang-chef/releases/download/${CHEF_VERSION}/chef-x86_64-unknown-linux-musl.tar.gz" && \
  tar xzf \
    /tmp/chef.tar.gz -C \
    /usr/local/bin/ && \
  chown root:root /usr/local/bin/chef && \
  chmod 755 /usr/local/bin/chef && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8080

VOLUME /recipes
