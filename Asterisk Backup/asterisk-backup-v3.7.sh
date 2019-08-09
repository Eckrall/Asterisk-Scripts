#!/bin/bash
#
# Creates backups of essential Asterisk configuration files & log files.
#
# 3.7 - Fixed the alerting mails and bug with sending mail
#
# Add this to the crontab!
# # Asterisk Backup #
# 00 04 * * * /backup/asterisk-backup.sh 1> /dev/null 2>&1
#
#
# Settings
CLIENT=`cat /backup/backup-settings.sh | grep CLIENT | awk -F\' '{print $2}'`
CONF_PATH=`cat /backup/backup-settings.sh | grep CONF_PATH | awk -F\' '{print $2}'`
LOG_PATH=`cat /backup/backup-settings.sh | grep LOG_PATH | awk -F\' '{print $2}'`

# Script Version
VER="3.7"

# Confirmation Email
EMAIL="XXXXX"

# URL to check for version updates
UPDATE=`curl http://XXX/asterisk_backup_script/version`

# No need to edit this as it is our server it is backing up too
HOST='XXXX'
USER='XXXX'
PASSWD='XXXX'

DAILY_LOG=DAILY-`date +%Y%m%d`-asterisk-logs.tar.gz
WEEKLY_LOG=WEEKLY-`date +%Y%m%d`-asterisk-logs.tar.gz
MONTHLY_LOG=MONTHLY-`date +%Y%m%d`-asterisk-logs.tar.gz

DAILY_CONF=DAILY-`date +%Y%m%d`-asterisk-conf.tar.gz
WEEKLY_CONF=WEEKLY-`date +%Y%m%d`-asterisk-conf.tar.gz
MONTHLY_CONF=MONTHLY-`date +%Y%m%d`-asterisk-conf.tar.gz

WEEK_DAY=`date +%w`
MONTH_END=`date +%d`

if (( $(bc <<< "$UPDATE > $VER") ))
then
        wget -O /backup/asterisk-backup.sh http://XXXX/asterisk_backup_script/asterisk-backup.sh
        chmod 755 /backup/asterisk-backup.sh
        echo "" | /bin/mail -s "Subject: Asterisk Backup Updated from $VER to $UPDATE on $CLIENT" $EMAIL
fi

if [ $WEEK_DAY -ge 0 ]
then
        tar cfz /backup/$DAILY_LOG $LOG_PATH 2>/dev/null
        tar cfz /backup/$DAILY_CONF $CONF_PATH 2>/dev/null
  
FTP=`ftp -n -v $HOST >/tmp/ftpstatus <<START 
quote USER $USER
quote PASS $PASSWD
binary
mkdir $CLIENT
cd $CLIENT
delete $CLIENT-asterisk-logs.tar.gz
delete $CLIENT-asterisk-conf.tar.gz
put /backup/$DAILY_LOG $CLIENT-asterisk-logs.tar.gz
put /backup/$DAILY_CONF $CLIENT-asterisk-conf.tar.gz
quit
START`

FTP_STATUS=`grep "226 File receive OK" /tmp/ftpstatus | wc -l`

        if [ $FTP_STATUS -eq 2 ] 

        then

                echo "FTP Backup OK!" >>/tmp/ftpstatus
				cat /tmp/ftpstatus | /bin/mail -s "Subject: Asterisk Backup: $CLIENT - Script Version $VER - FTP Succeeded!" $EMAIL 

        else 
                cat /tmp/ftpstatus | /bin/mail -s "Subject: Asterisk Backup: $CLIENT - Script Version $VER - FTP FAILED!" $EMAIL 
        fi

        /usr/bin/find /backup/DAILY*asterisk-logs* -mtime +30 -exec rm -f {} \;
        /usr/bin/find /backup/DAILY*asterisk-conf* -mtime +30 -exec rm -f {} \;

fi

if [ $WEEK_DAY -eq 0 ]
        then
                /bin/cp /backup/$DAILY_LOG /backup/$WEEKLY_LOG 2>/dev/null
                /bin/cp /backup/$DAILY_CONF /backup/$WEEKLY_CONF 2>/dev/null

                /usr/bin/find /backup/WEEKLY*asterisk-logs* -mtime +30 -exec rm -f {} \;
                /usr/bin/find /backup/WEEKLY*asterisk-conf* -mtime +30 -exec rm -f {} \;
fi

if [ $MONTH_END -eq 28 ]
        then
                /bin/cp /backup/$DAILY_LOG /backup/$MONTHLY_LOG 2>/dev/null
                /bin/cp /backup/$DAILY_CONF /backup/$MONTHLY_CONF 2>/dev/null

                /usr/bin/find /backup/MONTHLY*asterisk-logs* -mtime +168 -exec rm -f {} \;
                /usr/bin/find /backup/MONTHLY*asterisk-conf* -mtime +168 -exec rm -f {} \;

fi

/bin/rm /tmp/ftpstatus
