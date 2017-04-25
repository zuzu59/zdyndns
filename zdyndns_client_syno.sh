#!/bin/ash
#Petit client bash pour le zDynDNS
#zf170425.1523

export PATH=/opt/bin:/opt/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin

while true
do
	date
	THEIP=$(/sbin/ifconfig eth0 | /bin/grep "inet ad" | /usr/bin/cut -f2 -d: | /usr/bin/awk '{print $1}')
	ZSTR=$(hostname)
	echo $THEIP
	echo $ZSTR

	echo "s "$ZSTR" "$THEIP | nc sdftests.epfl.ch 3318
	sleep `expr $RANDOM % 5 + 10`s
done
