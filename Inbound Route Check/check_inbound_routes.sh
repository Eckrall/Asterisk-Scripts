#!/bin/bash
#
# Script to check inbound routes and alert if missing
#
# V1 kevin@eckrall.co.uk
#
# Add below to crontab
# Check inbound routes
# */5 * * * * /opt/tools/check_inbound_routes.sh 

inboundroute=`cat /etc/asterisk/inbound_source.include | fgrep [ | sed -e 's/^.//' -e 's/.$//' | sort | uniq`
host=`hostname`
for i in $inboundroute
        do
			source=`grep $i /etc/asterisk/inbound.include | awk '{print $3}' | awk -F, '{print $1}'`
			sourcelines=`echo $source | wc -m`
				if [ $sourcelines -le 1 ]
					then
						echo  "Missing Route $i on $host" | /bin/mail -s "Missing Route!!!!" me@you.com
						echo -e  "Missing Route $i on $host \n"
				fi
        done