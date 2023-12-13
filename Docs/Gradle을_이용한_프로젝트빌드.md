## Gradle을 이용한 프로젝트 빌드

다비치마켓 프로젝트는 빌드 자동화 도구인 Gradle을 사용한다. 프로젝트를 빌드하기위해서는 몇가지 Command line 옵션이 필요하다.

### Command line arguments
#### Dspring.profiles.active :
프로젝트 빌드에 사용될 프로파일로 ```local```, ```dev```, ```sandbox```, ```stage```를 사용 할수 있다.

프로파일을 운영환경에 따라 지정하여 사용한다.
  - local : 로컬 개발 환경에서 사용
  - dev : 테스트를 위한 Docker에 배포시 사용
  - sandbox : 테스트 서버 배포시 사용
  - stage : 운영화경 서버 배포시 사용

<span style="color:chocolate">운영환경에 따른 구성이 미비하여 현재 Stage 만 사용한다. 운영환경에 따른 프로젝트 구성이 필요하다.</span>

#### Drevision :
프로젝트의 버전을 명시할 수 있다. 버전을 명시하지 않을 경우 ```0.0.1-SNAPSHOT``` 이 기본으로 지정된다.

#### Dtarget :
빌드할 서비스를 지정한다. ```admin```, ```web```, ```mobile```, ```smsemail```, ```image```, 
```interface.mall```, ```interface.erp```, ```batch``` 를 지정할 수 있으며, 지정하지 않을 경우
모든 서비스를 빌드 한다. 빌드시간 단축을 위해 필요한 서비스만 지정하여 빌드한다.

#### Example:
```shell
PROFILE=stage
REVISION=0.0.1-stage
TARGET=web
./gradlew build --exclude-task test \
                -Dspring.profiles.active=${PROFILE} \
                -Drevision=${REVISION}\
                -Dtarget=${TARGET}
```