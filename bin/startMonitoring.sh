#!/bin/bash

cd conf
rm -rf nohup.out

nohup ruby /Monitoring/openstack/conf/cdc-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/ctf3-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/ctf4-monitoring.rb &
#nohup ruby /Monitoring/openstack/conf/dalstg1-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/dalstg2-monitoring.rb &
#nohup ruby /Monitoring/openstack/conf/dfwstg1-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/dfwstg2-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/dal1-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/dal2-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/dal3-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/dal4-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/dfw1-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/dfw2-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/dfw3-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/dfw4-monitoring.rb &
nohup ruby /Monitoring/openstack/conf/daliaas1-monitoring.rb &
