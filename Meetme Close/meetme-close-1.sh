#/bin/sh
# Script to close all meetme conferences
# V 1.1 kevin@eckrall.co.uk

MEETME=`/usr/sbin/asterisk -rx "meetme list concise" | awk -F! '{print $1}'`

for n in $MEETME
        do
                /usr/sbin/asterisk -rx"meetme kick $n all"
        done
	