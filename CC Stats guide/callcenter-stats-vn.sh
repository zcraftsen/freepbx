#!/bin/bash
rm -f $webpath/$date.html
date=`date +%Y-%m-%d`
path=/var/www/html/callback/
webpath=/var/www/html/callback/stats/Total
mkdir $webpath
cd $path
php index.php > $webpath/$date.html
chown asterisk:asterisk $webpath -R
sed -i 's/TODAY TLScontact Call back！/TLScontact Call back History/g' $webpath/$date.html
#sed -i 's/<a href="\/backup">Backup folder<\/a>/ /g' $webpath/$date.html
echo '<br \>' >> $webpath/$date.html

echo "<br \>" >> $webpath/$date.html
echo "Client vn2fr" >> $webpath/$date.html
echo "<br \>" >> $webpath/$date.html
echo  "---------------------------<br \>" >> $webpath/$date.html
echo  "Total calls received:" >> $webpath/$date.html
#find /data/asterisk/queue2mail/unziped/data/asterisk/queue2mail -maxdepth 1 -type f -mtime 0 | wc -l >> $webpath/$date.html
find /data/asterisk/queue2mail/unziped/data/asterisk/queue2mail /data/asterisk/queue2mail/backup/$(date --rfc-3339 date)/empty /data/asterisk/queue2mail/backup/$(date --rfc-3339 date)/wrongnum -maxdepth 1 -mtime 0 -type f -name "*.todo"| wc -l >> $webpath/$date.html
echo "<br \>" >> $webpath/$date.html
echo "Total calls need CB service:"  >> $webpath/$date.html
ls /data/asterisk/queue2mail/*.todo | wc -l  >> $webpath/$date.html
echo "<br \>" >> $webpath/$date.html
echo "Correct callback number:" >> $webpath/$date.html
find /data/asterisk/queue2mail/unziped/data/asterisk/queue2mail/ -maxdepth 1 -mtime 0 -type f -name "*.todo" | wc -l >> $webpath/$date.html
echo "<br \>" >> $webpath/$date.html
echo "Empty callback number:"  >> $webpath/$date.html
ls /data/asterisk/queue2mail/backup/$(date --rfc-3339 date)/empty/*.todo | wc -l  >> $webpath/$date.html
echo "<br \>" >> $webpath/$date.html
echo "Wrong callback number:"  >> $webpath/$date.html
ls /data/asterisk/queue2mail/backup/$(date --rfc-3339 date)/wrongnum/*.todo | wc -l  >> $webpath/$date.html


echo "<br \>" >> $webpath/$date.html
echo "<hr \>" >> $webpath/$date.html

echo "Client vn2ch" >> $webpath/$date.html
echo "<br \>" >> $webpath/$date.html
echo  "---------------------------<br \>" >> $webpath/$date.html
echo  "Total calls received:" >> $webpath/$date.html
#find /data/asterisk/vn2ch-queue2mail/unziped/data/asterisk/vn2ch-queue2mail -maxdepth 1 -type f -mtime 0 | wc -l >> $webpath/$date.html
find /data/asterisk/vn2ch-queue2mail/unziped/data/asterisk/vn2ch-queue2mail/ /data/asterisk/vn2ch-queue2mail/backup/$(date --rfc-3339 date)/empty /data/asterisk/vn2ch-queue2mail/backup/$(date --rfc-3339 date)/wrongnum -maxdepth 1 -mtime 0 -type f -name "*.todo" | wc -l >> $webpath/$date.html
echo "<br \>" >> $webpath/$date.html
echo "Total calls need CB service:"  >> $webpath/$date.html
ls /data/asterisk/vn2ch-queue2mail/*.todo | wc -l  >> $webpath/$date.html
echo "<br \>" >> $webpath/$date.html
echo "Correct callback number:" >> $webpath/$date.html
find /data/asterisk/vn2ch-queue2mail/unziped/data/asterisk/vn2ch-queue2mail/ -maxdepth 1 -mtime 0 -type f -name "*.todo" | wc -l >> $webpath/$date.html
echo "<br \>" >> $webpath/$date.html
echo "Empty callback number:"  >> $webpath/$date.html
ls /data/asterisk/vn2ch-queue2mail/backup/$(date --rfc-3339 date)/empty/*.todo | wc -l  >> $webpath/$date.html
echo "<br \>" >> $webpath/$date.html
echo "Wrong callback number:"  >> $webpath/$date.html
ls /data/asterisk/vn2ch-queue2mail/backup/$(date --rfc-3339 date)/wrongnum/*.todo | wc -l  >> $webpath/$date.html

echo "<br \>" >> $webpath/$date.html
echo "<hr \>" >> $webpath/$date.html

echo '<a href="/callback-stats/index.php">Back to call-back main menu</a>' >>  $webpath/$date.html
echo "</body>
</html>" >>  $webpath/$date.html