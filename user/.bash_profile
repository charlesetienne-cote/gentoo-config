# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
	if [ $(ps otty= $$) = "tty1" ] ; then
		WHOAMI=$(whoami)
		if [ $WHOAMI != 'root' ]; then
			export $(dbus-launch)
			export QT_WAYLAND_RECONNECT=1
			export SSH_ASKPASS="/usr/bin/ksshaskpass"
			export QT_AUTO_SCREEN_SCALE_FACTOR=0
			export KDE_FULL_SESSION=true
			export KDE_SESSION_VERSION=6
			export KDE_SESSION_UID=$(id -u)
			export XDG_CURRENT_DESKTOP="KDE"
			export KDE_APPLICATIONS_AS_SCOPE=1
			export XDG_MENU_PREFIX="plasma-"
			export XDG_CONFIG_DIRS="/home/$WHOAMI/.config/kdedefaults:/etc/xdg"
			export LANG="fr_CA.utf8"
			export XDG_SESSION_TYPE="wayland"
			kwin_wayland_wrapper > /dev/null &
			KWIN_PID=$!
			export WAYLAND_DISPLAY="wayland-0"
			gentoo-pipewire-launcher restart > /dev/null &
			kded6 > /dev/null &
			/usr/libexec/at-spi-bus-launcher --launch-immediately > /dev/null &
			gmenudbusmenuproxy > /dev/null &
			/usr/lib64/libexec/kglobalacceld > /dev/null &
			/lib64/libexec/pam_kwallet_init > /dev/null &
			/usr/lib64/libexec/polkit-kde-authentication-agent-1 > /dev/null &
			xdg-user-dirs-update > /dev/null &
			/usr/lib64/libexec/org_kde_powerdevil > /dev/null &
			plasmashell > /dev/null &
			easyeffects --gapplication-service > /dev/null &
			/usr/bin/firefoxpwa site launch 01HG8VMTYV6ETT2DA7AE21H2VY > /dev/null &
			/home/charles/Configuration/Signal.sh > /dev/null &
			synology-drive autostart > /dev/null &
			thunderbird > /dev/null &
			wait $KWIN_PID
			killall --user $WHOAMI
			logout
		fi
	fi
fi
