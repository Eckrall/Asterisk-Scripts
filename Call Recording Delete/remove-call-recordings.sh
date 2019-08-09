#!/bin/bash
#
#Script to remove call recordings over 30 days with optional exclusion list
#
#  V 1 kevin@eckrall.co.uk

# exclusion list in the format of '! -iname *name*'
EXCLUDE="! -iname *ahmedia*"


/usr/bin/find /var/spool/asterisk/monitor/ -mtime +30 -type f \( $EXCLUDE \) -exec ls -lah {} \;
#/usr/bin/find /var/spool/asterisk/monitor/* -mtime +90 -exec rm -f {} \;