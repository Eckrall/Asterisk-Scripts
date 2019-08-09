#!/bin/bash
#
# Script to show mac address, user agent and other stuff
#
# V1.5 kevin@eckrall.co.uk

TENANT=`asterisk -rx"sip show peers" | grep -a "$1" | grep -a "D" | cut -f 1 -d "/"`

echo "NAME,EXTN,IP,MAC,USERAGENT"
	for EXTN in $TENANT
		do
		IP=`asterisk -rx"sip show peers" | grep -wa "$EXTN" | awk '{print $2}'`
		MAC=`more /proc/net/arp | grep -wa "$IP" | awk '{print $4}'`
			if [ ! -n "$MAC" ]
				then
				MAC=`grep $EXTN /tftpboot/* 2>/dev/null | grep -a "1.address=" | cut -c 11-22`
			fi
	NAME=`asterisk -rx"sip show peer $EXTN" | grep -a "Callerid     :" | awk '{print $3}' | tr -d '"'`
	USERA=`asterisk -rx"sip show peer $EXTN" | grep -a "Useragent    :" | awk '{print $3}'`
	echo "$NAME,$EXTN,$IP,$MAC,$USERA"
	done