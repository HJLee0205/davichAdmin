
export JAVA_HOME="/usr/lib/jvm/jre-1.8.0"
export CATALINA_HOME="/app/image/"
export CATALINA_BASE="/app/image/"

export SERVER_NAME="image"
export JVM_ROUTE="was10"
export HTTP_PORT=""
export HTTPS_PORT=""
export AJP_PORT="8181"
export SHUTDOWN_PORT="58015"

export JAVA_OPTS="${JAVA_OPTS} -server"
export JAVA_OPTS="${JAVA_OPTS} -DjvmRoute=${JVM_ROUTE}"
export JAVA_OPTS="${JAVA_OPTS} -Dport.http=${HTTP_PORT}"
export JAVA_OPTS="${JAVA_OPTS} -Dport.https=${HTTPS_PORT}"
export JAVA_OPTS="${JAVA_OPTS} -Dport.ajp=${AJP_PORT}"
export JAVA_OPTS="${JAVA_OPTS} -Dport.shutdown=${SHUTDOWN_PORT}"
echo ${JAVA_OPTS}


export GC_LOG_HOME=/app/logs/image/gc
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
export CATALINA_OPTS="${CATALINA_OPTS} -XX:HeapDumpPath=/app/logs/image"
export CATALINA_OPTS="${CATALINA_OPTS} -Djava.security.egd=file:/dev/./urandom"

echo ${CATALINA_OPTS}
