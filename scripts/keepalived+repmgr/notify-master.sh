#!/bin/bash

REPMGR_CONF='/etc/repmgr/9.5/repmgr.conf'

su postgres -c 'repmgr -f /etc/repmgr/9.5/repmgr.conf standby promote'
