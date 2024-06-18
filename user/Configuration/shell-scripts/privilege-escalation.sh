__privilege-escalation () {
	local WHOAMI=$(whoami)
	if [ $WHOAMI = 'root' ]; then
		echo "You can't do this as root"
	else
		doas bash "$1"
	fi
}