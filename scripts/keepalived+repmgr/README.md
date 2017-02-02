# Intro

The scripts are tested and should only require minor config changes. We'd recommend automating all these scripts + configuration in whichever way preferred. The bulk of the scripts are self-explanatory. The master keepalived config has comments that explains the details of the config.

These template scripts will allow you to do this following:

- Setup repmgr on your database cluster
- Setup keepalived
- Setup an automatic failover through keepalived and repmgr (without repmgrd)
- Setup barman

# Setting up repmgr

We'll setup a single master, multiple standby cluster.

* Setup `repmgr.conf` for master (given sample)
* Setup `postgresql.conf` for master (given sample)
* Create a repmgr user
> createuser -s repmgr
* Create a repmgr db
> createdb repmgr -O repmgr
* Ensure the repmgr user has appropriate permissions in `pg_hba.conf` (given sample) and can connect in replication mode
* Register the master
> repmgr -f repmgr.conf master register
* Setup `repmgr.conf` for standby (given sample)
* Clone the standby
> repmgr -h repmgr_node1 -U repmgr -d repmgr -D /path/to/node2/data/ -f /etc/repmgr.conf standby clone
* Register the standby
> repmgr -f /etc/repmgr.conf standby register

Rinse and repeat for any more standbys.

# Setting up keepalived

* Install keepalived
* There are 3 keepalived.conf files provided. 1 is master, the other two are primary and secondary standbys

## Failover mechanism

The master is kept with a higher priority with the `nopreempt` option on. The standbys *will not* have the `nopreempt` option. The first standby (preferably sync) will have a lower priority. The secondary standby has an even lower priority. There are appropriate scripts in this repository that need to also be deployed for the failover to take place. These scripts include: health check, master promotion, standby follow.

# Things to keep in mind

* Do not run repmgrd
* Make sure failover is set to `manual` in the repmgr.conf file since we failover using keepalived and not repmgrd (provided sample repmgr.conf)

# Some useful commands

### assigning a new synchronous standby without downtime

* assuming node1 is master and node2 is primary sync standby, node3 is secondary sync standby
* node2 will be set as sync
* node3 will be kept as async unless and until node2 fails

> psql -c \"ALTER SYSTEM SET synchronous_standby_names TO 'node2,node3';\"

> psql -c \"select pg_reload_conf();\""

> psql -c \"SELECT application_name, sync_state FROM pg_stat_replication;\"

### finding out how far a slave is behind master

> psql -c \"SELECT pg_catalog.pg_last_xlog_receive_location();"

### how to get a failed master back as a standby

* kill keepalived
* make sure priority on keepalived.conf is changed to something lower than current master and the other standby
* point it to the new master in

* restart keepalived
> systemcttl restart keepalived.service

* try to boot it up
* if it cannot catch up, run a clone
