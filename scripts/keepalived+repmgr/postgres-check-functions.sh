check_psql_connect() {
    local result=`psql -U "${1:-postgres}" -p "${2:-5432}" -h "${3:-localhost}" -d "${4:-postgres}" -w -q -t -c 'select 1;' | head -n 1 | tr -d ' '`
    [[ $? -le 0 ]] && [[ "${result}" = "1" ]] && return 0
    return 1
}

check_psql_master() {
    local result=`psql -U "${1:-postgres}" -p "${2:-5432}" -h "${3:-localhost}" -d "${4:-postgres}" -w -q -t -c 'select pg_is_in_recovery();' | head -n 1 | tr -d ' '`
    [[ $? -le 0 ]] && [[ "${result}" = "f" ]] && return 0
    return 1
}
