
echo '--------------------------------------------------------------------------------'
echo Service Mode : $SPRING_PROFILES_ACTIVE
echo Host Name : $HOSTNAME
echo '--------------------------------------------------------------------------------'
export JAVA_HOME="/usr/lib/jvm/jre-1.8.0"
export CATALINA_HOME="/app/admin/"
export CATALINA_BASE="/app/admin/"

export SERVER_NAME="admin"
export JVM_ROUTE="was8"
export HTTP_PORT=""
export HTTPS_PORT=""
export AJP_PORT="9090"
export SHUTDOWN_PORT="8016"

export JAVA_OPTS="${JAVA_OPTS} -server"
export JAVA_OPTS="${JAVA_OPTS} -DjvmRoute=${JVM_ROUTE}"
export JAVA_OPTS="${JAVA_OPTS} -Dport.http=${HTTP_PORT}"
export JAVA_OPTS="${JAVA_OPTS} -Dport.https=${HTTPS_PORT}"
export JAVA_OPTS="${JAVA_OPTS} -Dport.ajp=${AJP_PORT}"
export JAVA_OPTS="${JAVA_OPTS} -Dport.shutdown=${SHUTDOWN_PORT}"
echo ${JAVA_OPTS}


export GC_LOG_HOME=/app/logs/admin/gc
export GC_LOG=${GC_LOG_HOME}/gc_${SERVER_NAME}_`date "+%Y%m%d%H"`.log

export CATALINA_OPTS="${CATALINA_OPTS} -Xms4096m -Xmx4096m -XX:NewSize=1024m -XX:MaxNewSize=1024m -XX:PermSize=1024m -XX:MaxPermSize=1024m"
export CATALINA_OPTS="${CATALINA_OPTS} -verbose:gc"
export CATALINA_OPTS="${CATALINA_OPTS} -Xloggc:${GC_LOG}"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:ParallelGCThreads=2"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:-UseConcMarkSweepGC"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:-PrintGC"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:-PrintGCDetails"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:-PrintGCTimeStamps"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:-TraceClassUnloading"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:-TraceClassLoading"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:+UseParallelGC"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:+UseParallelOldGC"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:+UseAdaptiveSizePolicy"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:+PrintGCDetails"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:+PrintGCTimeStamps"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:+DisableExplicitGC"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:+HeapDumpOnOutOfMemoryError"
export CATALINA_OPTS="${CATALINA_OPTS} -XX:HeapDumpPath=/app/logs/admin"
export CATALINA_OPTS="${CATALINA_OPTS} -Djava.security.egd=file:/dev/./urandom"

# 리모트 디버깅
export JPDA_ADDRESS=5001
export JPDA_TRANSPORT=dt_socket

echo ${CATALINA_OPTS}
