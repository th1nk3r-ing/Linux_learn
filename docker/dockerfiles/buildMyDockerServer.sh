#!/bin/bash

# 单独构建并压缩 Ubuntu 服务
build_ubuntu() {
  docker build -t my-ubuntu-server ../../config/ -f ./DockerfileUbuntu

  docker-squash --tag my-ubuntu-server:latest my-ubuntu-server
}

# 单独构建并压缩 Alpine 服务
build_alpine() {
  docker build -t my-alpine-server ../../config/ -f ./DockerfileAlpine

  docker-squash --tag my-alpine-server:latest my-alpine-server
}


build_ubuntu
build_alpine
