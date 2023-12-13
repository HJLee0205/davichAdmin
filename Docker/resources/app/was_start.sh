#!/bin/sh

#front
if [ -z "`ps -eaf | grep java|grep /app/front/`" ]; then
        /app/front/bin/startup.sh
		echo "front is being started."
else
       echo "front was started."
fi 

#mfront
if [ -z "`ps -eaf | grep java|grep /app/mfront/`" ]; then
        /app/mfront/bin/startup.sh
		echo "front is being started."
else
       echo "mfront was started."
fi 

#admin
if [ -z "`ps -eaf | grep java|grep /app/admin/`" ]; then
        /app/admin/bin/startup.sh
		echo "admin is being started."
else
       echo "admin was started."
fi 

#ifapi_erp
if [ -z "`ps -eaf | grep java|grep /app/ifapi_erp/`" ]; then
       /app/ifapi_erp/bin/startup.sh
	   echo "ifapi_erp is being started."
else
	echo "ifapi_erp was started."
        
fi 

#ifapi_mall
if [ -z "`ps -eaf | grep java|grep /app/ifapi_mall/`" ]; then
       /app/ifapi_mall/bin/startup.sh
	   echo "ifapi_mall is being started."
else
      echo "ifapi_mall was started."
fi 

#kiosk
#if [ -z "`ps -eaf | grep java|grep /app/kiosk/`" ]; then
#        /app/kiosk/bin/startup.sh
#		echo "kiosk is being started."
#else
#       echo "kiosk was started."
#fi

#image
#if [ -z "`ps -eaf | grep java|grep /app/image/`" ]; then
#        /app/image/bin/startup.sh
#		echo "image is being started."
#else
#       echo "image was started."
#fi 

#batch
if [ -z "`ps -eaf | grep java|grep /app/batch/`" ]; then
        /app/batch/bin/startup.sh
		echo "batch is being started."
else
       echo "batch was started."
fi

ps -eaf | grep java