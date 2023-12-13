#!/bin/sh

#front
if [ -z "`ps -eaf | grep java|grep /app/front/`" ]; then
       echo "front was not started."
else
       ps -eaf | grep java | grep /app/front/ | awk '{print $2}' |
       while read PID
               do
               echo "Killing $PID ..."
               kill -9 $PID
               echo
               echo "front  is being shutdowned."
               done
        /app/front/bin/startup.sh
fi 

#mfront
if [ -z "`ps -eaf | grep java|grep /app/mfront/`" ]; then
       echo "mfront was not started."
else
       ps -eaf | grep java | grep /app/mfront/ | awk '{print $2}' |
       while read PID
               do
               echo "Killing $PID ..."
               kill -9 $PID
               echo
               echo "mfront  is being shutdowned."
               done
        /app/mfront/bin/startup.sh
fi 

#admin
if [ -z "`ps -eaf | grep java|grep /app/admin/`" ]; then
       echo "admin was not started."
else
       ps -eaf | grep java | grep /app/admin/ | awk '{print $2}' |
       while read PID
               do
               echo "Killing $PID ..."
               kill -9 $PID
               echo
               echo "admin  is being shutdowned."
               done
        /app/admin/bin/startup.sh
fi 

#ifapi_erp
if [ -z "`ps -eaf | grep java|grep /app/ifapi_erp/`" ]; then
       echo "ifapi_erp was not started."
else
       ps -eaf | grep java | grep /app/ifapi_erp/ | awk '{print $2}' |
       while read PID
               do
               echo "Killing $PID ..."
               kill -9 $PID
               echo
               echo "ifapi_erp  is being shutdowned."
               done
        /app/ifapi_erp/bin/startup.sh
fi 

#ifapi_mall
if [ -z "`ps -eaf | grep java|grep /app/ifapi_mall/`" ]; then
       echo "ifapi_mall was not started."
else
       ps -eaf | grep java | grep /app/ifapi_mall/ | awk '{print $2}' |
       while read PID
               do
               echo "Killing $PID ..."
               kill -9 $PID
               echo
               echo "ifapi_mall  is being shutdowned."
               done
        /app/ifapi_mall/bin/startup.sh
fi 

#kiosk
if [ -z "`ps -eaf | grep java|grep /app/kiosk/`" ]; then
       echo "kiosk was not started."
else
       ps -eaf | grep java | grep /app/kiosk/ | awk '{print $2}' |
       while read PID
               do
               echo "Killing $PID ..."
               kill -9 $PID
               echo
               echo "kiosk  is being shutdowned."
               done
        /app/kiosk/bin/startup.sh
fi 

image
if [ -z "`ps -eaf | grep java|grep /app/image/`" ]; then
       echo "image was not started."
else
       ps -eaf | grep java | grep /app/image/ | awk '{print $2}' |
       while read PID
               do
               echo "Killing $PID ..."
               kill -9 $PID
               echo
               echo "image  is being shutdowned."
               done
        /app/image/bin/startup.sh
fi

batch
if [ -z "`ps -eaf | grep java|grep /app/batch/`" ]; then
       echo "batch was not started."
else
       ps -eaf | grep java | grep /app/batch/ | awk '{print $2}' |
       while read PID
               do
               echo "Killing $PID ..."
               kill -9 $PID
               echo
               echo "batch  is being shutdowned."
               done
        /app/batch/bin/startup.sh
fi

ps -eaf | grep java