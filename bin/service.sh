#!/bin/bash

function SERVICE_START(){
  # $1 배포서버

  echo ---- SERVICE START -------------------------------------------------
  echo Server : ${1}
  ssh -i ./bin/public_key/oci_Davich_rsa opc@${1} sudo /app/was_start.sh
  sleep 3m
  ssh -i ./bin/public_key/oci_Davich_rsa opc@${1} sudo httpd -k start
}

function SERVICE_STOP(){
  # $1 배포서버

  echo ---- SERVICE STOP -------------------------------------------------
  echo Server : ${1}
  ssh -i ./bin/public_key/oci_Davich_rsa opc@${1} sudo httpd -k stop
  ssh -i ./bin/public_key/oci_Davich_rsa opc@${1} sudo /app/was_stop.sh
}
