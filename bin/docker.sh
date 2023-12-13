#!/bin/bash

function BUILD_DOCKER(){
  docker build ./Docker --tag ${DOCKER_IMAGE}
}

function RUN_DOCKER() {

#docker run --rm -it -p 8080:80 -p 8443:443 \
#    -v /Users/kmoh/Projects/O4OPJT:/data/O4OPJT \
#    -v $PROJECT_ROOT/Docker/resources/app:/app \
#    -v ~/Projects/davichmarket/Docker/resources/httpd/conf:/etc/httpd/conf \
#    -v ~/Projects/davichmarket/Docker/resources/httpd/conf.d:/etc/httpd/conf.d \
#    --name davichmarket davichmarket:0.1 bash

# 리모트 디버깅 포트
# admin   : 5001
# web     : 5002
# mobile  : 5003

  docker stop davichmarket
  docker rm davichmarket
  docker run --rm -it \
      -p ${HTTP_PORT}:80 \
      -p ${HTTPS_PORT}:443 \
      -p 15001:5001 \
      -p 15002:5002 \
      -p 15003:5003 \
      -p 15004:5004 \
      -p 15005:5005 \
      -p 15006:5006 \
      -v ${PROJECT_ROOT}/build:/data/O4OPJT \
      -e SPRING_PROFILES_ACTIVE=${PROFILE} \
      --name davichmarket ${DOCKER_IMAGE} bash
}

function RUN_DOCKER_CLIENT() {
  docker run --rm  --name firefox -e DISPLAY=$IP:0 -e XAUTHORITY=/.Xauthority \
      --add-host www.davichmarket.com:$IP \
      --net host \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      -v ~/.Xauthority:/.Xauthority \
      jess/firefox
}