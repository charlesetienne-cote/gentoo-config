WHOAMI=$(whoami)
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
if [ $WHOAMI = 'root' ]; then
	echo "You can't do this as root"
else
	doas bash -c "\
	cp --recursive --force --reflink=auto $SCRIPT_DIR/etc/. /etc;\
	cp --force --reflink=auto $SCRIPT_DIR/linux/.config /usr/src/linux/.config;\
	doas -u $WHOAMI cp --recursive --force --reflink=auto $SCRIPT_DIR/user/. /home/$WHOAMI;\
	doas -u $WHOAMI bash -c \"echo \\\"source /home/$WHOAMI/.config/theme/envvar\\\" >> /home/$WHOAMI/.bashrc\";\
	doas -u $WHOAMI bash -c \"echo \\\"export PATH=\\\\\\\"\\\\\\\$PATH:/home/$WHOAMI/.local/bin\\\\\\\"\\\" >> /home/$WHOAMI/.bashrc\";\
	doas -u $WHOAMI bash -c \"echo \\\"export GENTOO_CONFIG_DIR=$SCRIPT_DIR\\\" >> /home/$WHOAMI/.bashrc\";\
	doas -u $WHOAMI bash -c \"echo \\\"source /home/$WHOAMI/Configuration/aliases.sh\\\" >> /home/$WHOAMI/.bashrc\";"
	exec bash
fi