#!/bin/sh

#cat /usr/local/etc/rc.d/zdyndns_daemon_syno.sh



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
