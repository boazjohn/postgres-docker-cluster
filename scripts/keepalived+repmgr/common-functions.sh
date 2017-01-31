check_process() {
	local port="${1}"
	[[ -z "${port}" ]] && return 1
	killall -0 "${port}" > /dev/null 2>&1 # this is cheaper than pidof and ps
	return $?
}

# check if process with pid from file $1 exists
check_pid_file() {
	local port="$1"
	[[ -z "${port}" ]] && return 1
	[[ -f "${port}" ]] || return 1
	kill -0 `head -n 1 "${port}"` > /dev/null 2>&1
	return $?
}

exit_err() {
	message="${1:-Unknown}"
	echo `date`"${0}.${_svc} ${message}" >> "${LOG}"
	exit ${2:-1}
}
