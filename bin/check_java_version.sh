#!/bin/bash

if [[ -n $JAVA_HOME ]];
then
JAVA=${JAVA_HOME}/bin/java
else
JAVA='java'
fi

JAVA_VERSION=$(${JAVA} -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1)

# todo : Java 1.8 버전을 찾는 기능 추가
# /usr/lib/jvm/jre-1.8.0
# /Library/Java/JavaVirtualMachines/jre-1.8.0/Contents/Home
# ~/Library/Java/JavaVirtualMachines/jre-1.8.0/Contents/Home

ERROR=0

if [ $JAVA_VERSION -gt '8' ]
then
  echo 'Java Version 1.8이상은 지원하지 않습니다.'
  ERROR=-1
fi

if [ $JAVA_VERSION -lt '8' ]
then
  echo 'Java Version 1.8이하는 지원하지 않습니다.'
  ERROR=-1
fi

if [ $ERROR -lt 0 ]
then
  echo 'Java 1.8 버전을 사용해주세요.'
  echo '환경변수 JAVA_HOME 또는 --jre 옵션을 사용하여 Java 1.8 홈 디렉토리를 지정할 수 있습니다.'
  exit -1
fi
