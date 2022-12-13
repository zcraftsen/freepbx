<html>
<body>
<br />
<hr />
<?php
$filename = 'footer.php';
$fmtime = filemtime($filename);
//if (!$fmtime) {
    echo "This is a draft page,<br> Last time modified: " . date ("F d Y H:i:s.", $fmtime);
//}
?>

</body>
</html>