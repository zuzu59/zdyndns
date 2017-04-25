#!/bin/ash
#Petit client bash zDynDNS pour Synology
#zf170425.1418

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
