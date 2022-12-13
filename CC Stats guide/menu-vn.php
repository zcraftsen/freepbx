<html>
<body>

<?php
echo '<a href="/callback">For vn2fr</a>'."\r\n";
echo ('<br>');
//echo exec('echo Total Calls: $(find /data/asterisk/queue2mail/unziped/data/asterisk/queue2mail -maxdepth 1 -type f -mtime 0 | wc -l)')."\r\n";
echo exec('echo Total Calls: ');
echo ' '.exec('find /data/asterisk/queue2mail/unziped/data/asterisk/queue2mail /data/asterisk/queue2mail/backup/$(date --rfc-3339 date)/empty /data/asterisk/queue2mail/backup/$(date --rfc-3339 date)/wrongnum -maxdepth 1 -mtime 0 -type f -name "*.todo" | wc -l');
//find /data/asterisk/queue2mail/unziped/data/asterisk/queue2mail -maxdepth 1 -type f -mtime 0 | wc -l 2>&1');
echo ('<br>');
echo ('<br>');
echo exec('echo Calls Need service: $(ls /data/asterisk/queue2mail/*.todo | wc -l)');
echo ('<br>');
//echo exec('echo Correct callback number: $(find /data/asterisk/queue2mail/unziped/data/asterisk/queue2mail -daystart -ctime 0 -type f -name "*.todo" | wc -l)');
echo exec('echo Correct callback number: $(find /data/asterisk/queue2mail/unziped/data/asterisk/queue2mail -maxdepth 1 -mtime 0 -type f -name "*.todo" | wc -l)');
echo ('<br>');
echo exec('echo Empty callback number: $(ls /data/asterisk/queue2mail/backup/$(date --rfc-3339 date)/empty/*.todo | wc -l)');
echo ('<br>');
echo exec('echo Wrong callback number: $(ls /data/asterisk/queue2mail/backup/$(date --rfc-3339 date)/wrongnum/*.todo | wc -l)');
echo ('<br>');
echo ('<br>');

echo '<a href="/vn2ch-callback">For vn2ch</a>'."\r\n";
echo ('<br>');
echo exec('echo Total Calls: $(find /data/asterisk/vn2ch-queue2mail/unziped/data/asterisk/vn2ch-queue2mail/ /data/asterisk/vn2ch-queue2mail/backup/$(date --rfc-3339 date)/empty /data/asterisk/vn2ch-queue2mail/backup/$(date --rfc-3339 date)/wrongnum -maxdepth 1 -mtime 0 -type f -name "*.todo" | wc -l)')."\r\n";
//find /data/asterisk/vn2ch-queue2mail/unziped/data/asterisk/vn2ch-queue2mail -maxdepth 1 -type f -mtime 0 | wc -l)')."\r\n";
echo ('<br>');
echo ('<br>');
echo exec('echo Calls Need service: $(ls /data/asterisk/vn2ch-queue2mail/*.todo | wc -l)');
echo ('<br>');
echo exec('echo Correct callback number: $(find /data/asterisk/vn2ch-queue2mail/unziped/data/asterisk/vn2ch-queue2mail -maxdepth 1 -mtime 0 -type f -name "*.todo" | wc -l)');
echo ('<br>');
echo exec('echo Empty callback number: $(ls /data/asterisk/vn2ch-queue2mail/backup/$(date --rfc-3339 date)/empty/*.todo | wc -l)');
echo ('<br>');
echo exec('echo Wrong callback number: $(ls /data/asterisk/vn2ch-queue2mail/backup/$(date --rfc-3339 date)/wrongnum/*.todo | wc -l)');
echo ('<br>');
echo ('<br>');
echo '<a href="/callback-stats/Total">Stats History</a>'."\r\n";

include 'footer.php';
?>