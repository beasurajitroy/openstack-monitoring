if [ `ps -ef | grep "openstack-aggregator.conf" | grep -v grep | awk '{print $2}' | wc -l` = 0 ]
        then
        echo "Starting Openstack Indexer Instance"
       /Monitoring/logstash-1.4.2/bin/logstash agent -f /Monitoring/openstack/conf/openstack-aggregator.conf -l /Monitoring/openstack/logs/openstack-aggregator-indexer.log &
else
        echo "Openstack Indexer INSTANCE IS ALREADY RUNNING"
fi
