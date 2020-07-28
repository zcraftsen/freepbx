#!/bin/bash
#FILES=`find /data/asterisk/vn2ch-queue2mail/unziped/data/asterisk/vn2ch-queue2mail/ -maxdepth 1 -mtime 0 -type f | grep todo && find /data/asterisk/vn2ch-queue2mail/backup/$(date --rfc-3339 date)/empty -maxdepth 1 -mtime 0 -type f | grep todo && find /data/asterisk/vn2ch-queue2mail/backup/$(date --rfc-3339 date)/wrongnum -maxdepth 1 -mtime 0 -type f | grep todo`

#FILES=`find /data/asterisk/queue2mail/unziped/data/asterisk/queue2mail/ -daystart -ctime 0 -type f | grep todo && find /data/asterisk/queue2mail/backup/$(date --rfc-3339 date)/empty | grep todo && find /data/asterisk/queue2mail/backup/$(date --rfc-3339 date)/wrongnum | grep todo`

#FILES=`find /data/asterisk/queue2mail/unziped/data/asterisk/queue2mail/ -daystart -ctime 0 -type f | grep todo && find /data/asterisk/queue2mail/backup/$(date --rfc-3339 date)/empty | grep todo && find /data/asterisk/queue2mail/backup/$(date --rfc-3339 date)/wrongnum | grep todo`

FILES=`find /data/asterisk/vn2ch-queue2mail/unziped/data/asterisk/vn2ch-queue2mail/ /data/asterisk/vn2ch-queue2mail/backup/$(date --rfc-3339 date)/empty /data/asterisk/vn2ch-queue2mail/backup/$(date --rfc-3339 date)/wrongnum -maxdepth 1 -mtime 0 -type f -name "*.todo"`

date=`date +%Y-%m-%d`
for file in $FILES
do
callbacknum=$(cat $file | head -3 | tail -1)
if [[ $(echo $callbacknum) ]]; then
  echo "number ok"
else
  echo "empty"
#rm -rf $file
fi

if [ `stat --format=%Y $file` -le $(( `date +%s` - 60 )) ]; then
        if [[ $(cat $file | grep "agent 1") ]]; then
        echo "answered"
###
# Stats generator here. Don't code like this!

year=$(cat $file | head -1 | awk -F "-" {'print $1'} | awk -F "/" {'print $3'})
day=$(cat $file | head -1 | awk -F "-" {'print $1'} | awk -F "/" {'print $2'})
month=$(cat $file | head -1 | awk -F "-" {'print $1'} | awk -F "/" {'print $1'})

callbackinitdate=$(cat $file | head -1 | sed 's/-/ /g' | sed 's/\// /g' | sed 's/:/ /g' | awk {'print $3"-"$1"-"$2";"$4":"$5":"$6'})
callbackprocdate=$(stat -t -c %y $file | awk -F "." {'print $1'} | awk -F " " {'print $1";"$2'})
phonedetected=$(cat $file | head -2 | tail -1)
phoneentered=$(cat $file | head -3 | tail -1)
callpbxid=$(cat $file | head -4 | tail -1)
callagent=$(cat $file | head -5 | tail -1 | sed 's/agent //g')


callbackinityear=$(cat $file | head -1 | awk -F "-" {'print $1'} | awk -F "/" {'print $3'})
callbackinitday=$(cat $file | head -1 | awk -F "-" {'print $1'} | awk -F "/" {'print $2'})
callbackinitmonth=$(cat $file | head -1 | awk -F "-" {'print $1'} | awk -F "/" {'print $1'})
callbackinithour=$(cat $file | head -1 | awk -F "-" {'print $2'} | awk -F ":" {'print $1'})
callbackinitminute=$(cat $file | head -1 | awk -F "-" {'print $2'} | awk -F ":" {'print $2'})
callbackinitsecond=$(cat $file | head -1 | awk -F "-" {'print $2'} | awk -F ":" {'print $3'})

#get the call's time stamp
callbackinitepoch=$(date +%s --date "$callbackinityear-$callbackinitmonth-$callbackinitday $callbackinithour:$callbackinitminute:$callbackinitsecond")
#echo 'callbackinitepoch='$callbackinitepoch

#get the current date
callbackprocdate=$(stat -t -c %y $file | awk -F "." {'print $1'} | awk -F " " {'print $1" "$2'})
#echo 'callbackprocdate=' $callbackprocdate

#get the timestamp
callbackprocepoch=$(date +%s --date "$callbackprocdate")
#echo 'callbackprocepoch=' $callbackprocepoch
#stat -t -c %y $1
holdtime=$(expr $callbackprocepoch - $callbackinitepoch)


echo $callbackinitepoch"|"$callpbxid"|id2fr|NONE|DID|"$phonedetected"-"$phoneentered >> /data/asterisk/log/queue_log
echo $callbackinitepoch"|"$callpbxid"|id2fr|NONE|ENTERQUEUE||"$phonedetected"-"$phoneentered >> /data/asterisk/log/queue_log
echo $callbackprocepoch"|"$callpbxid"|id2fr|"$callagent"|CONNECT|"$holdtime"|"$callpbxid"|1">> /data/asterisk/log/queue_log
echo $callbackprocepoch"|"$callpbxid"|id2fr|"$callagent"|COMPLETEAGENT|"$holdtime"||1">> /data/asterisk/log/queue_log


        fi
fi

done