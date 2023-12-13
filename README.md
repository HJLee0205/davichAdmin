
* [프로젝트구조](Docs/프로젝트구조.md)
* [Gradle을 이용한 프로젝트 빌드](Docs/Gradle을_이용한_프로젝트빌드.md)
* [스크립트를 이용한 프로젝트 관리](Docs/스크립트를_이용한_프로젝트_관리.md)


테스트 계정 : test@cndf.com, qlalfqjsgh1234!

## 프로젝트 설정
  기본 설정은 local 개발을 위한 설정이며, dev, sandbox, product 를 위한 설정을 함께 할수 있다.

  * 데이터베이스 설정
    * ```modules/common/src/main/resources/datasource.yml```
  * 도메인, URL, Path등 시스테 운영에 필요한 기본 설정
    * ```modules/common/src/main/resources/system.yml```
  * 로그 레벨 설정
    * ```modules/common/src/main/resources/logback.yml```
  * ehcache 설정 
    * ```modules/common/src/main/resources/cache.yml```

## 프로젝트 빌드

profile 옵션은 local, dev, sandbox, product 를 사용한다.
옵션을 사용하지 않았을경우 기본값은 local 이다.

 - local : local 개발환경에서 테스트 빌드
 - dev : 개발환경에서 테스트 빌드
 - sandbox : 배포전 sandbox 환경에서 테스트 비들
 - product : 운영환경을 위한 빌드

```bash
$ gradlew clean build -Dspring.profiles.active=dev
```

## 프로젝트 실행 옵션
  - -Dprofile=dev                          // 프로 젝트 빌드에서 사용되는 옵셥과 동일
  - -Dlog.name=admin                       // 필수 옵션. 로그 저장시 사용될 이름
  - -Djava.net.preferIPv4Stack=true        // ehcache 의 멀티캐스팅 오류 해결

## macOS 에서 서비스 실행시 유의 사항
### 멀티캐스팅 오류
macOS 에서 실행시 아래 와 같은 오류가 발생하는 경우가 있다. 

```
java.net.SocketException: Can't assign requested address
	at java.net.PlainDatagramSocketImpl.join(Native Method)
	at java.net.AbstractPlainDatagramSocketImpl.join(AbstractPlainDatagramSocketImpl.java:178)
	at java.net.MulticastSocket.joinGroup(MulticastSocket.java:323)
```

해당 문제는 ipv6 전용 네트워크에 멀티캐스팅을 위한 ipv4를 사용하여 발생하는 오류이다. 
```-Djava.net.preferIPv4Stack=true```을 사용하여 JVM이 ipv6 전용 네트워크 인터페이스를 기본 네트워크 인터페이스로 
선택하지 않도록 하여 문제를 해결 할수 있다. 

java.net.MulticastSocket#setInterface() 를 호출하여 자동으로 ipv4 네트워크 인터페이스를 사용하도록 할 수 도 있다.

### org.apache.commons.codec 라이브러리 충돌
```commons-codec:commons-codec:1.15``` 의 ```org.apache.commons.codec``` 을 사용해야하지만 
```uer-ksf-client-1.2.jar``` 내의 ```org.apache.commons.codec``` 을 사용하여 ```dmall.framework.common.util.CryptoUtil```
에서 오류가 발생한다.  ```uer-ksf-client-1.2.jar``` 에서 ```org.apache.commons.codec``` 을 제거한다.
```bash
$ mkdir tmp
$ mv uber-ksf-client-1.2.jar tmp/
$ jar -cvf uber-ksf-client-1.2.jar
$ cd tmp
$ rm -rf org/apache/commons/code
$ jar -cmf META-INF/MANIFEST.MF ../uber-ksf-client-1.2.jar *
```

### Docker를 이용한 테스트

#### Project Build 
```bash
# -p : 빌드 프로파일 'local, dev, sandbox, product
./build.sh build -p=dev
```

#### Docker Image 생성
```bash
./build.sh docker
```



#### Docker 웹브라우저 실행
웹브라우저에서 www.davichmarket.com 를 이용하여 테스트 할 수 있도록 웹 브라우저를 실행한다.

```bash
docker run --rm  --name firefox -e DISPLAY=$IP:0 -e XAUTHORITY=/.Xauthority \
    --add-host www.davichmarket.com:$IP \
    --net host \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/.Xauthority:/.Xauthority \
    jess/firefox
```

### MacOS 에서 포트 포워딩, root 사용자가 아니면  80 번 포트를 사용하지 못함
```bash
1. 아래 위치로 이동!
    cd /etc/pf.anchors/
2. 편집기 실행!
    sudo vi com.pow
3. 아래 내용 작성후 저장
    rdr pass on lo0 inet proto tcp from any to any port 80 -> 127.0.0.1 port 8080
    rdr pass on lo0 inet proto tcp from any to any port 443 -> 127.0.0.1 port 8443
4. 편집기 실행 !
    sudo vi /etc/pf.conf
5. rdr-anchor "com.apple/*" 이 내용 아랫줄에 내용추가!
    rdr-anchor "pow"
6. load anchor "com.apple" from "/etc/pf.anchors/com.apple" 이 내용 아랫줄에 내용 추가 후 저장 !
    load anchor "pow" from "/etc/pf.anchors/com.pow"
7. 아래 명령 실행 !
    sudo pfctl -f /etc/pf.conf
8. 아래 명령 실행 !
    sudo pfctl -e
    
    
# 모든 포트 사용가능 하도록 한다.
sudo pfctl -F all
```

### 테스트 관리자 계정
 - id : admin@test.com
 - pw : qlalfqjsgh1234!
