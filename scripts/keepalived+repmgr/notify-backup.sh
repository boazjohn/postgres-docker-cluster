#!/bin/bash

REPMGR_CONF='/etc/repmgr/9.5/repmgr.conf'
REPMGR_USER='repmgr'
POSTGRES_DATA='/var/lib/pgsql/9.5/data/'
REPMGR_DB='repmgr'
VIRTUAL_IP='172.16.24.6'

su postgres -c 'repmgr -f /etc/repmgr/9.5/repmgr.conf -D /var/ligb/pgsql/9.5/data/ -h 172.16.24.6 -U repmgr -d repmgr standby follow'
