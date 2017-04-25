#!/bin/sh
#Petit daemon qui démarre au boot du Synology pourle zDynDNS à mettre dans:
#cat /usr/local/etc/rc.d/zdyndns_daemon_syno.sh
#zf170425.1530

case $1 in
    start)
	/root/zdyndns_client_syno.sh 2>&1 </dev/null &
        exit 0
        ;;
    stop)
	killps /root/zdyndns_client_syno.sh
        exit 0
        ;;
    *)
esac
