# Intro

The scripts are tested and should only require minor config changes. We'd recommend automating all these scripts + configuration in whichever way preferred. The bulk of the scripts are self-explanatory. The master keepalived config has comments that explains the details of the config.

# Failover mechanism

The master is kept with a higher priority with the `nopreempt` option on. The first standby (preferably sync) has lower priority. The secondary standby has an even lower priority. There are appropriate scripts in this repository that need to also be deployed for the failover to take place. These scripts include: health check, master promotion, standby follow.

# Some useful commands

### assigning a new synchronous standby without downtime

* assuming node1 is master and node2 is primary sync standby, node3 is secondary sync standby
* node2 will be set as sync
* node3 will be kept as async unless and until node2 fails

> psql -c \"ALTER SYSTEM SET synchronous_standby_names TO 'node2,node3';\"

> psql -c \"select pg_reload_conf();\""

> psql -c \"SELECT application_name, sync_state FROM pg_stat_replication;\"

#### finding out how far a slave is behind master

> psql -c \"SELECT pg_catalog.pg_last_xlog_receive_location();"

###
