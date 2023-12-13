#!/bin/bash

function EXPLODE(){
  echo "> EXPLODE"
  echo "    from : ${1}"
  echo "      to : ${2}"
  rm -rf ${2}
  unzip -o -d ${2} ${1} | awk 'BEGIN {ORS="."} {if(NR%50==0)print "."}'
  echo " "
}

function DISTRIBUTE() {
  # $1 프로젝트 이름
  # $2 프로젝트 소스 디랙토리
  # $3 프로젝트 빌드 디렉토리

  mkdir -p ${3}
  EXPLODE ${2}/build/libs/davichmarket.${1}-${REVISION}.war ${3}
  chmod -R 777 ${3}
}

function BUILD() {
  # Java Version 체크
  source ./bin/check_java_version.sh

  ./gradlew build --exclude-task test \
            -Dspring.profiles.active=${PROFILE} \
            -Drevision=${REVISION}\
            -Dtarget=${TARGET}

  EACH_TARGET DISTRIBUTE

  echo ""
  echo "REVISION=${REVISION}"
  echo "COMPLETED BUILD!!!!"
  echo ""
}
