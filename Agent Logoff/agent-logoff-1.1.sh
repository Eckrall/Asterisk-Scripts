#/bin/sh
# Script to logoff all queue members
# V 1.1 kevin@eckrall.co.uk

MEMBER=`/usr/sbin/asterisk -rx "queue show" | egrep "  SIP/" | cut -c7-14 | sort -u`
QUEUE=`/bin/grep "\\[*\\]" /etc/asterisk/queues.conf |  tr -d "\[\]" | grep -v queuename`

for q in $QUEUE
        do
                        for m in $MEMBER
                                do

                                        echo "Removing Agent $m from Queue $q" >>/backup/agent-logoff/logoff.log
                                       /usr/sbin/asterisk -rx"queue remove member $m from $q"
                        done
        done

/usr/sbin/asterisk -rx "queue reset stats"
echo "Run complete, showing current Queues" >>/backup/agent-logoff/logoff.log
echo `/usr/sbin/asterisk -rx"queue show"` >>/backup/agent-logoff/logoff.log

echo "----------End of current run `date +%Y-%m-%d:%H-%M` ----------" >>/backup/agent-logoff/logoff.log