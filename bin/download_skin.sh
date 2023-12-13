#!/bin/bash

function DN_SKIN(){

  if [ $SKIN_SERVER = '' ]
  then
    echo "스킨을 다운 받기 위한 서버 주소를 입력해주세요."
    exit -1
  fi

  rm -rf ${PROJECT_ROOT}/src/services/web/src/main/webapp/WEB-INF/views/site/id1/__SKIN
  rm -rf ${PROJECT_ROOT}/src/services/mobile/src/main/webapp/WEB-INF/views/site/id1/__MSKIN

  scp -r -C -i ${PROJECT_ROOT}/bin/public_keys/oci_Davich_rsa opc@${1}:/data/O4OPJT/front/ROOT/WEB-INF/views/site/id1/__SKIN \
            ${PROJECT_ROOT}/src/services/web/src/main/webapp/WEB-INF/views/site/id1/

  scp -r -C -i ${PROJECT_ROOT}/bin/public_keys/oci_Davich_rsa opc@${1}:/data/O4OPJT/mfront/m/WEB-INF/views/site/id1/__MSKIN \
            ${PROJECT_ROOT}/src/services/mobile/src/main/webapp/WEB-INF/views/site/id1/

}