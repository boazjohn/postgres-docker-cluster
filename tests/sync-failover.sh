#!/usr/bin/env bash

for i in {1..5}
do
    docker-machine rm --force default
    docker-machine create -d virtualbox --virtualbox-disk-size "30000" default
    docker-machine start default
    eval "$(docker-machine env default)"
    docker-compose build && docker-compose up -d
    echo "\n\n\n\n\n\n ############# SLEEPING NOW ############ \n\n\n\n\n\n"
    sleep 60

    docker-compose exec pgmaster bash -c "gosu postgres psql -c \"ALTER SYSTEM SET synchronous_standby_names TO 'node2,node3,node4,node5';\""
    docker-compose exec pgmaster bash -c "gosu postgres psql -c \"select pg_reload_conf();\""
    docker-compose exec pgmaster bash -c "gosu postgres psql -c \"SELECT application_name, sync_state FROM pg_stat_replication;\""

    docker-compose exec pgslave3 bash -c "tc qdisc add dev eth0 root netem delay 200ms"

    docker-compose exec pgmaster bash -c "gosu postgres pgbench -i -s 100" -T -d

    docker-compose exec pgslave1 bash -c "gosu postgres psql -c \"SELECT pg_catalog.pg_last_xlog_receive_location();\""
    docker-compose exec pgslave3 bash -c "gosu postgres psql -c \"SELECT pg_catalog.pg_last_xlog_receive_location();\""

    echo "\n\n\n\n\n\n ############# KILLING MASTER NOW ############ \n\n\n\n\n\n"
    docker-compose kill pgmaster

    for i in {1..10}
    do
	docker-compose exec pgslave3 bash -c "gosu postgres repmgr cluster show" | grep "master" | cut -c 1-20 >> ./stdout.log
	sleep 6
    done
    echo "test run complete" >> ./stdout.log
done
