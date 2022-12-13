<html>
<body>

<?php
//echo '<a href="/callback-cn2ch/index.php">For CN2CH-CN&EN</a>';
echo '<a href="../callback">For ph2ch</a>'."\r\n";
echo ('<br>');
echo exec('echo Total Calls: $(find /data/asterisk/ph2ch-queue2mail/unziped/data/asterisk/ph2ch-queue2mail -maxdepth 1 -type f -mtime 0 | wc -l)')."\r\n";
echo ('<br>');
echo exec('echo Calls Need service: $(ls /data/asterisk/ph2ch-queue2mail/*.todo | wc -l)');
echo ('<br>');
echo ('<br>');
echo ('<br>');
echo ('<br>');
echo ('<hr \>');
echo ('<br>');
echo ('<br>');
echo '<a href="/callback/stats/Total">Stats History</a>'."\r\n";

include 'footer.php';
?>