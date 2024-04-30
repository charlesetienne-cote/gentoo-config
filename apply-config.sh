WHOAMI=$(whoami)
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
if [ $WHOAMI = 'root' ]; then
	echo "You can't do this as root"
else
	doas bash -c "\
	cp --recursive --force --reflink=always $SCRIPT_DIR/etc/* /etc;\
	doas -u $WHOAMI cp --recursive --force --reflink=always $SCRIPT_DIR/user/* /home/$WHOAMI;\
	doas -u $WHOAMI cp --recursive --force --reflink=always $SCRIPT_DIR/user/.bashrc /home/$WHOAMI/.bashrc;\
	doas -u $WHOAMI bash -c \"echo \\\"source /home/$WHOAMI/.config/theme/envvar\\\" >> /home/$WHOAMI/.bashrc\";\
	doas -u $WHOAMI bash -c \"echo \\\"export PATH=\\\\\\\"\\\\\\\$PATH:/home/$WHOAMI/.local/bin\\\\\\\"\\\" >> /home/$WHOAMI/.bashrc\";\
	doas -u $WHOAMI bash -c \"echo \\\"export GENTOO_CONFIG_DIR=$SCRIPT_DIR\\\" >> /home/$WHOAMI/.bashrc\";\
	doas -u $WHOAMI bash -c \"echo \\\"source /home/$WHOAMI/Configuration/aliases.sh\\\" >> /home/$WHOAMI/.bashrc\";"
	source /home/$WHOAMI/.bashrc
fi