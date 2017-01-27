#!/bin/bash

REPMGR_CONF=''

repmgr -f "${REPMGR_CONF}" standby promote
