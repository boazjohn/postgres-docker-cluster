PSQL_PID_FILE='/var/lib/postgresql/9.1/main/postmaster.pid'
PSQL_PORT='5432'
PSQL_USER=''
PSQL_HOST=''
PSQL_DBNAME=''
PSQL_LOCALIP="localhost"
PSQL_REMOTEIP="${2:-127.0.0.1}"
LOG='check-psql-vrrp.log'

. ./common-functions.sh || exit 1
. ./postgres-check-functions.sh || exit 1

check_pid_file "${PSQL_PID_FILE}" || exit_err 'pid_file' 1
check_listen_port "${PSQL_PORT}" || exit_err 'listen_port' 1
check_psql_connect "${PSQL_USER}" "${PSQL_PORT}" "${PSQL_LOCALIP}" "${PSQL_DBNAME}" || exit_err 'psql_connect: Connect failure' 1
