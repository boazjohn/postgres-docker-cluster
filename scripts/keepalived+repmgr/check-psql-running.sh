PSQL_PID_FILE='/var/lib/pgsql/9.5/data/postmaster.pid'
PSQL_PORT='5432'
PSQL_USER='postgres'
PSQL_HOST='localhost'
PSQL_DBNAME='postgres'
PSQL_LOCALIP="localhost"
LOG='/var/log/keepalived.log'

. ./common-functions.sh || exit 1
. ./postgres-check-functions.sh || exit 1

check_pid_file "${PSQL_PID_FILE}" || exit_err 'pid_file' 1
check_psql_connect "${PSQL_USER}" "${PSQL_PORT}" "${PSQL_LOCALIP}" "${PSQL_DBNAME}" || exit_err 'psql_connect: Connect failure' 1
