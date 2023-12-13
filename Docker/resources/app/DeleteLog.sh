#!/bin/sh
#생성된지 7일이 지난 로그를 삭제하는 스크립트

find /app/admin/logs/*.log -type f -mtime +7 -exec rm -f {} \;
find /app/batch/logs/*.log -type f -mtime +7 -exec rm -f {} \;
find /app/front/logs/*.log -type f -mtime +7 -exec rm -f {} \;
find /app/ifapi_erp/logs/*.log -type f -mtime +7 -exec rm -f {} \;
find /app/ifapi_mall/logs/*.log -type f -mtime +7 -exec rm -f {} \;
find /app/image/logs/*.log -type f -mtime +7 -exec rm -f {} \;
find /app/kiosk/logs/*.log -type f -mtime +7 -exec rm -f {} \;
find /app/mfront/logs/*.log -type f -mtime +7 -exec rm -f {} \;

find /app/admin/logs/*.txt -type f -mtime +7 -exec rm -f {} \;
find /app/batch/logs/*.txt -type f -mtime +7 -exec rm -f {} \;
find /app/front/logs/*.txt -type f -mtime +7 -exec rm -f {} \;
find /app/ifapi_erp/logs/*.txt -type f -mtime +7 -exec rm -f {} \;
find /app/ifapi_mall/logs/*.txt -type f -mtime +7 -exec rm -f {} \;
find /app/image/logs/*.txt -type f -mtime +7 -exec rm -f {} \;
find /app/kiosk/logs/*.txt -type f -mtime +7 -exec rm -f {} \;
find /app/mfront/logs/*.txt -type f -mtime +7 -exec rm -f {} \;
