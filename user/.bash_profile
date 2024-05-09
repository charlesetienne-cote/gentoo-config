# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
	if [ $(ps otty= $$) = "tty1" ] ; then
		dbus-launch --exit-with-session startplasma-wayland
		rm --recursive --force ~/tmp
		logout
	fi
fi
