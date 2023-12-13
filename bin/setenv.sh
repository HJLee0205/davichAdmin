#!/bin/bash

PROFILE="local"
JAVA_HOME=$JAVA_HOME
REVISION=`date "+%Y%m%d.%H.%M"`
HTTP_PORT=80
HTTPS_PORT=443
DOCKER_IMAGE=davichmarket
TARGET='all'


SERVER_WAS1=132.145.84.122
SERVER_WAS2=140.238.21.67
SERVER_WAS3=140.238.7.213
SERVER_WAS4=132.145.87.244
SERVER_WAS_TEST1=146.56.170.193
SERVER_IMAGE1=140.238.7.163
SERVER_IMAGE2=140.238.7.92

SERVER_STAGE=${SERVER_WAS1},${SERVER_WAS2},${SERVER_WAS3}
SERVER_SANDBOX=${SERVER_WAS_TEST1}
SERVER_PUSH=140.238.20.115
SERVER_IMAGE=${SERVER_IMAGE1},${SERVER_IMAGE2}

PROJECTS=(
  # 별칭, 이름, 프로젝트위치, 빌드위치
  interface.erp,-,${PROJECT_ROOT}/src/services/interface/erp,${PROJECT_ROOT}/build/ifapi_erp/ifapi_erp,/data/O4OPJT/ifapi_erp/ifapi_erp,
  interface.mall,-,${PROJECT_ROOT}/src/services/interface/mall,${PROJECT_ROOT}/build/ifapi_mall/ifapi_mall,/data/O4OPJT/ifapi_mall/ifapi_mall,
  image,-,${PROJECT_ROOT}/src/services/image,${PROJECT_ROOT}/build/image/ROOT,/data/O4OPJT/image/ROOT,
  smsemail,-,${PROJECT_ROOT}/src/services/smsemail,${PROJECT_ROOT}/build/smsemail/ROOT,/data/O4OPJT/smsemail/ROOT,
  batch,-,${PROJECT_ROOT}/src/services/batch,${PROJECT_ROOT}/build/batch/ROOT,/data/O4OPJT/batch/ROOT,
  admin,-,${PROJECT_ROOT}/src/services/admin,${PROJECT_ROOT}/build/admin/ROOT,/data/O4OPJT/admin/ROOT,
  web,-,${PROJECT_ROOT}/src/services/web,${PROJECT_ROOT}/build/front/ROOT,/data/O4OPJT/front/ROOT,
  mobile,-,${PROJECT_ROOT}/src/services/mobile,${PROJECT_ROOT}/build/mfront/m,/data/O4OPJT/mfront/m,
)