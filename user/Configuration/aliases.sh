alias neofetch="neowofetch"
alias update-config="$GENTOO_CONFIG_DIR/apply-config.sh"

#Si conflit:
#emerge --ask --verbose --update --deep --newuse --with-bdeps=y --ignore-world *PaquetEnConflit*
#revdep-rebuild --pretend
#revdep-rebuild

cleanup () {
	local WHOAMI=$(whoami)
	if [ $WHOAMI = 'root' ]; then
		echo "You can't do this as root"
	else
		doas bash -c "\
		cd /usr/src/linux;\
		make clean;\
		emerge --ask --depclean;\
		eclean distfiles;\
		eclean packages;\
		CCACHE_DIR=/var/cache/ccache/ doas -u $WHOAMI ccache -C;\
		doas -u $WHOAMI rm --recursive --force /home/$WHOAMI/.npm;\
		doas -u $WHOAMI rm --recursive --force /home/$WHOAMI/.pki;\
		doas -u $WHOAMI rm --recursive --force /home/$WHOAMI/.cache"
	fi
}

snapshot () {
	local WHOAMI=$(whoami)
	if [ $WHOAMI = 'root' ]; then
		echo "You can't do this as root"
	else
		doas bash -c "\
		doas -u $WHOAMI echo "Snapshot description: ";\
		read description;\
		snapper --config root create --read-write --description \$description"
	fi
}

update () {
	local WHOAMI=$(whoami)
	if [ $WHOAMI = 'root' ]; then
		echo "You can't do this as root"
	else
		doas bash -c "\
		eix-sync;\
		emerge --ask --verbose --update --keep-going --backtrack=100 --deep --newuse --with-bdeps=y @world;\
		doas -u $WHOAMI cargo install-update -a
		npm update -g"
	fi
}

update-firefox () {
	local WHOAMI=$(whoami)
	if [ $WHOAMI = 'root' ]; then
		echo "You can't do this as root"
	else
		doas bash -c "\
		cp --force --reflink=auto /home/$WHOAMI/Configuration/policies.json /usr/lib64/firefox/distribution/policies.json;\
		doas -u $WHOAMI rm --recursive --force /home/$WHOAMI/.local/share/firefoxpwa/runtime/*;\
		doas -u $WHOAMI cp --recursive --force --reflink=always /usr/lib64/firefox/* /home/$WHOAMI/.local/share/firefoxpwa/runtime;\
		doas -u $WHOAMI /home/$WHOAMI/Configuration/updater.sh -bsu -p /home/$WHOAMI/.mozilla/firefox/tiuh6kpf.default;\
		doas -u $WHOAMI /home/$WHOAMI/Configuration/updater.sh -bsu -p /home/$WHOAMI/.local/share/firefoxpwa/profiles/01HJ1KP19PYVD4GAMRV06VD3B4;\
		doas -u $WHOAMI /home/$WHOAMI/Configuration/updater.sh -bsu -p /home/$WHOAMI/.local/share/firefoxpwa/profiles/01HWRZKY7VECNT8ZQHKJYKESN5;\
		doas -u $WHOAMI /home/$WHOAMI/Configuration/updater.sh -bsu -p /home/$WHOAMI/.local/share/firefoxpwa/profiles/01HG8W8V0HE1T552RSDE6T5S4F;\
		doas -u $WHOAMI /home/$WHOAMI/Configuration/updater.sh -bsu -p /home/$WHOAMI/.local/share/firefoxpwa/profiles/01HG8VMTPMBMRZQXJKKDEQH6KS;\
		doas -u $WHOAMI echo \"Check changelog (https://github.com/arkenfox/user.js/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3Achangelog)\""
	fi
}

update-freetube () {
	local WHOAMI=$(whoami)
	if [ $WHOAMI = 'root' ]; then
		echo "You can't do this as root"
	else
		cd /home/$WHOAMI/Git/FreeTubeAndroid
		yarn --pure-lockfile clean
		yarn --pure-lockfile upgrade
		yarn --pure-lockfile pack:web
	fi
}

update-kernel () {
	local WHOAMI=$(whoami)
	if [ $WHOAMI = 'root' ]; then
		echo "You can't do this as root"
	else
		doas bash -c "\
		snapper --config root cleanup all;\
		preNum=\$(snapper --config root create --type pre --print-number --cleanup-algorithm number);\
		doas -u $WHOAMI eselect kernel list;\
		doas -u $WHOAMI echo \"New Kernel\";\
		read kernelPos;\
		eselect kernel set \$kernelPos;\
		cd /usr/src/linux;\
		doas -u $WHOAMI echo \"Old kernel\";\
		read kernelOld;\
		cp /usr/src/\$kernelOld/.config /usr/src/linux;\
		make oldconfig;\
		make -j6;\
		find /boot -not -name 'memtest.efi64' -delete;\
		rm --recursive --force /lib/modules/*;\
		grub-install --efi-directory=/efi;\
		kernelVer=\$(doas -u $WHOAMI make --no-print-directory kernelversion);\
		make install;\
		mv /boot/vmlinuz /boot/vmlinuz-\$kernelVer;\
		dracut --force --kver \$kernelVer;\
		grub-mkconfig -o /boot/grub/grub.cfg;\
		snapper --config root create --type post --pre-number \$preNum --description \$kernelVer --cleanup-algorithm number;\
		doas -u $WHOAMI cp --force --reflink=auto /usr/src/linux/.config $GENTOO_CONFIG_DIR/linux/.config"
	fi
}

update-retry () {
	local WHOAMI=$(whoami)
	if [ $WHOAMI = 'root' ]; then
		echo "You can't do this as root"
	else
		doas bash -c "\
		until emerge --verbose --update --backtrack=100 --deep --newuse --with-bdeps=y --jobs=1 @world;\
		do\
			doas -u $WHOAMI echo \"Retrying at \`date -Iminutes\`\";\
		done"
	fi
}
