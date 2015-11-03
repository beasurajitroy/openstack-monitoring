cloud=$1

echo `date` "-- $cloud" >> /Monitoring/openstack/grafana-1.7.0/quotastatus/scripts/refreshquota.log

rubyfile="${cloud}-mon-refresh.rb"

exe="/Monitoring/openstack/grafana-1.7.0/quotastatus/scripts/${rubyfile}"

echo $exe >> /Monitoring/openstack/grafana-1.7.0/quotastatus/scripts/refreshquota.log

ruby $exe

sleep 5

chmod 777 /Monitoring/openstack/grafana-1.7.0/quotastatus/${cloud}-status.php
