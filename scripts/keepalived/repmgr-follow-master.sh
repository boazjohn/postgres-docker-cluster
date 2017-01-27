#!/bin/bash

REPMGR_CONF=''
REPMGR_USER=''
POSTGRES_DATA=''
REPMGR_DB=''

repmgr -f "${REPMGR_CONF}" -D "${REPMGR_DB}" -h "${4}" -U "${REPMGR_USER}" -d "${REPMGR_DB}" standby follow
