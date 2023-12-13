#!/bin/bash

HELP() {
cat << EOM
다비치 마켓을 빌드, 테스트, 배포 한다.
ex) ./davich.sh build -p=dev

Commands:
  build                                   build 디렉토리에 프로젝트를 빌드한다.
  deploy                                  리모트 서버에 빌드된 war 파일을 배포한다.
  docker                                  Docker Image를 생성한다. (Docker 디렉토리에 Docker Image 생성정보가 있음)
  serve                                   Docker 를 이용하여 프로젝트를 실행 한다.
  client                                  Docker 웹브라우저를 오픈한다.
  dn-skin                                 서버에서 SKIN을 다운 받는다. ex) ./davich.sh dn-skin 132.145.84.122

                                          from :
                                            server:/data/O4OPJT/front/ROOT/WEB-INF/views/site/id1/__SKIN
                                            server:/data/O4OPJT/mfront/m/WEB-INF/views/site/id1/__MSKIN
                                          into :
                                            ./src/services/web/src/main/webapp/WEB-INF/views/site/id1/__SKIN
                                            ./src/services/mobile/src/main/webapp/WEB-INF/views/site/id1/__MSKIN


Options:
  -j, --jre                               빌드시 사용 할 Java 경로 (기본값: \$JAVA_HOME 환경변수)
  -r, --revision                          Revision (기본값: build - date "+%Y%m%d.%H.%M", deploy - 마지막 빌드시 사용한 revision)
  -p, --profile                           빌드시 사용할 프로파일 (local, dev, sandbox, stage) (기본값: local)
                                          운영을 위한 빌드는 stage를 사용한다.
  -t, --target                            빌드할 타켓 서비스 명 (admin, web, mobile, interface.erp, interface.mall, image, batch)
                                          (기본값: all)
                                          ex) -t=admin,web,mobile
  -s, --server                            배포할 서버 주소 목록
                                          ex) -s=146.56.170.193,146.56.170.193

Docker options:
  --tag                                   Docker Image 이름 (기본값: davichmarket)
  --http-port                                  Docker Host에 연결할 http 포트 (기본값: 8080)
  --https-port                            Docker Host에 연결할 https 연결 포트 (기본값: 8443)
  --image                                 사용할 Docker Image 이름 (기본값: davichmarket)
EOM
}

PROJECT_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ./bin/setenv.sh

cd ${PROJECT_ROOT}

for i in "$@"; do
  case $i in
  build|deploy-test|deploy|docker|serve|client)
    COMMAND=$i
    shift
  ;;
  dn-skin)
    COMMAND=$i
    shift
    SKIN_SERVER=${@}
    shift
  ;;
  -h|--help)
    HELP
    exit 0
  ;;
  -p=*|--profile=*)
    PROFILE="${i#*=}"
  ;;
  -r=*|--revision=*)
    REVISION="${i#*=}"
    shift
  ;;
  -j=*|--jre=*|--java=*)
    export JAVA_HOME="${i#*=}"
    shift
  ;;
  -t=*|--target=*)
    TARGET="${i#*=}"
  ;;
  --http-port=*)
    HTTP_PORT="${i#*=}"
    shift
  ;;
  --https-port=*)
    HTTPS_PORT="${i#*=}"
    shift
  ;;
  -s=*|--server=*)
    SERVER="${i#*=}"
    shift
  ;;
  -*|--*)
    shift
  ;;
  esac
done


REVISION="${REVISION}-${PROFILE}"
REVISION=$(echo ${REVISION}| awk '{print toupper($0)}')

function EACH_TARGET(){

  for i in ${PROJECTS[@]}
  do
    params=(`echo $i | tr "," "\n"`)
    if [ ${params[1]} = '-' ]
    then
      params[1]=${params[0]}
    fi

    pattern=$(echo '(.*'${params[0]}'.*|^all$)')
    if [[ $TARGET =~ $pattern ]]
    then
      $1 ${params[1]} ${params[2]} ${params[3]} ${params[4]} ${2} ${3}
    fi
  done
}

# build Script
source ./bin/build.sh

# deploy script
source ./bin/deploy.sh
source ./bin/service.sh

# docker image creating Script
source ./bin/docker.sh

source ./bin/download_skin.sh

if [ $COMMAND = "" ]
then
  HELP
  exit 0
fi

if [ $COMMAND = "build" ]
then
  BUILD
fi

if [ $COMMAND = "deploy" ]
then
  servers=(`echo ${SERVER} | tr "," "\n"`)

  for i in ${servers[@]}
  do
    SERVICE_STOP ${i}
  done

  for i in ${servers[@]}
  do
    EACH_TARGET DEPLOY ${i}
  done


  for i in ${servers[@]}
  do
    SERVICE_START ${i}
  done

fi

if [ $COMMAND = "deploy-test" ]
then
  DEPLOY_TEST
fi

if [ $COMMAND = "docker" ]
then
  BUILD_DOCKER
fi

if [ $COMMAND = "serve" ]
then
  RUN_DOCKER
fi

if [ $COMMAND = "dn-skin" ]
then
  DN_SKIN $SKIN_SERVER
fi

if [ $COMMAND = "client" ]
then
  RUN_DOCKER_CLIENT
fi




