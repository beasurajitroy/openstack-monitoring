<?php
    if (isset($_POST['button']))
    {
         exec('/Monitoring/openstack/grafana-1.7.0/phphome/shellscript.sh karthik');
    }
?>
<html>
<body>
    <form method="post">
        <button name="button" style="float: right;">Run Shell</button>
    </form>
</body>
