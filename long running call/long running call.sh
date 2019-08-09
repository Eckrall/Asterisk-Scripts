#!/bin/bash
#
# Checks for long running calls and sends alert.
# Check the awk print, some systems need 11, some 12?

TIMER=`/usr/sbin/asterisk -rx"core show channels concise" | awk -F! '{print$12}'`

for i in $TIMER
do
echo $i
if [ $i -gt 14400 ]
#if [ $i -gt 14 ]
then
       echo  "Hung Channel" | /bin/mail -s "Hung Channel $i" me@you.com
fi

done