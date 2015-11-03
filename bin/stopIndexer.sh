if [ `ps -ef | grep "openstack-aggregator.conf" | grep -v grep | awk '{print $2}' | wc -l` = 0 ]
        then
        echo "Openstack INDEXER IS NOT RUNNING"
else
        echo "Stopping Openstack Indexer Instance"
        procID=`ps -ef | grep "openstack-aggregator.conf" | grep -v grep | awk '{print $2}' `
        echo $procID
        kill -9 $procID
fi
