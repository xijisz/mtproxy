cd /root/
nohup mtproxy.sh start &
nohup ./gost -L=mtls://:8443/127.0.0.1:443 >/dev/null 2>&1 &
