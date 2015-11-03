
<?php

$name = $_REQUEST['name']; 
$command = "/Monitoring/openstack/grafana-1.7.0/quotastatus/scripts/quotagenerate.sh $name";
$lasttime = "/Monitoring/openstack/grafana-1.7.0/quotastatus/scripts/lasttime_$name.txt";
/*
1. Getting Current Time in UTC and converting to EPOCH.
2. Get Previous Refresh time and convert to EPOCH.
3. Check the difference and if its more than 1800 secs (ie. 30 minutes) then execute the ruby.
4. Else Alert the User about the last refresh time.
*/

date_default_timezone_set('UTC');
$timenow = date('Y-m-d H:i:s ', time()) ;
$epoch_current = strtotime($timenow);
$timefile = fopen($lasttime, "r");
while (!feof($timefile))
{

    $lastrefreshtime = fgets($timefile);
    $epoch_last = strtotime($lastrefreshtime);

    if (empty($epoch_last))
    {
        exec($command);
    	file_put_contents($lasttime, $timenow);
    	echo "Refreshing contents, Please wait for 30 seconds..!";
    }
    else
    {

    	$diff_epoch = $epoch_current - $epoch_last;

    	if ( $diff_epoch > 1800 )
    	{
            exec($command);  
    		file_put_contents($lasttime, $timenow);
    		echo "Refreshing contents, Please wait for 30 seconds..!";
    	}
    	else
    	{
    		echo "Last Refresh was done in < 30 minutes ago at " . $timenow . " UTC";
    	}
    }
}
return $name;

?>



