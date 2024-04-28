#!/bin/sh
echo "###############开机自启脚本###############"
nohup ./mtproxy.sh start >/dev/null 2>&1 &
nohup ./gost -L=mtls://:8443/127.0.0.1:443 >/dev/null 2>&1 &
