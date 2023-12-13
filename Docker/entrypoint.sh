#!/usr/bin/env sh

redis-server --daemonize yes
/app/was_start.sh
httpd -DFOREGROUND -k start
