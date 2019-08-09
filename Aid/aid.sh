#!/bin/bash
#
# Script takes 2 arguments,
# 1 is the Value you are grepping on
# 2 is the filename

#ID=`/bin/fgrep \`/bin/date +%Y-%m-%d\` $2| /bin/fgrep $1 | awk -F[ '{print $3}' | awk -F ] '{print $1}' | sort -u`
ID=`/bin/fgrep $1 $2  | awk -F[ '{print $3}' | awk -F ] '{print $1}' | sort -u`

for i in $ID

        do
                /bin/fgrep "[$i]" $2 > $i.txt

        done