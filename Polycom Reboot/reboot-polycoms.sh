#/bin/sh
# Script to reboot all polycom phones
# V 1.0 Kevin@eckrall.co.uk

PEER=`/usr/sbin/asterisk -rx "sip show peers" | awk '{print $1}' | cut -d / -f 1`

#echo $PEER

for p in $PEER

        do
                echo "Rebooting Extn $p" >>/opt/reboot-phones/reboot.log
                /usr/sbin/asterisk -rx"sip notify polycom-check-cfg $p"
        done
echo "----------End of current run `date +%Y-%m-%d:%H-%M` ----------" >>/opt/reboot-phones/reboot.log