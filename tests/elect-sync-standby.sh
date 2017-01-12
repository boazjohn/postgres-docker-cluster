#!/usr/bin/env bash

#
# call when event repmgrd_failover_promote is triggered
#
# sanity check in repl_nodes table for correct master and
# correct standbys as returned from the event
#
# find: sync standbys
#  if found:
#      do nothing
#  else
#      assign the most caught up standby and exit
#
