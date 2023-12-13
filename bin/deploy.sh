#!/bin/bash

function DEPLOY(){
  # $1 프로젝트 이름
  # $2 프로젝트 소스 디랙토리
  # $3 프로젝트 빌드 디렉토리
  # $4 배포서버 디렉토리
  # $5 배포서버

  echo ${5}
  ssh -i ./bin/public_key/oci_Davich_rsa opc@${5} sudo rm -rf ${4}
  scp -i ./bin/public_key/oci_Davich_rsa ${2}/build/libs/davichmarket.${1}-${REVISION}.war opc@${5}:${4}.war
}
