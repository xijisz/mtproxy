#!/bin/sh
#chkconfig:2345 80 90
#description: Run
echo "###############开机自启脚本###############"
source /etc/profile
cd /root/
bash mtproxy.sh start &
nohup gost -L=mtls://:8443/127.0.0.1:443 >/dev/null 2>&1 &
