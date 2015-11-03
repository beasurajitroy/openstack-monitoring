echo `date`
/Monitoring/openstack/bin/stopIndexer.sh
echo "Stopped the Indexer"
sleep 10
/Monitoring/openstack/bin/startIndexer.sh
echo "Started the indexer"
