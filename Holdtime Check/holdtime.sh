#/bin/sh
# Script to grab hold time
# V 1.0 Kevin@eckrall.co.uk

CALLID=`/bin/fgrep \`/bin/date +%Y-%m-%d\` /var/log/asterisk/full | fgrep "$1" | fgrep answered | fgrep "app_queue.c" | awk -F[ '{print $3}' | awk -F ] '{print $1}'`

for i in $CALLID

        do
			echo "CallID $i"
			/bin/fgrep `/bin/date +%Y-%m-%d` /var/log/asterisk/full | fgrep "[$i]" | fgrep -e "answered" -e "Started music on hold" -e "Stopped music on hold"
			echo ""
		done