alias neofetch="neowofetch"
alias update-config="source $GENTOO_CONFIG_DIR/apply-config.sh"

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
		find /usr/src -mindepth 1 -maxdepth 1 -not -name 'linux' -not -name \$(doas -u $WHOAMI readlink /usr/src/linux) -exec rm -rf {} \; ;\
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
		eselect news read new;\
		emerge --ask --verbose --update --keep-going --backtrack=100 --deep --newuse --with-bdeps=y @world;\
		doas -u $WHOAMI cp --force --reflink=auto /var/lib/portage/world $GENTOO_CONFIG_DIR/var/lib/portage/world
		doas -u $WHOAMI cargo install-update -a;\
		npm update -g"
	fi
}

update-firefox () {
	local WHOAMI=$(whoami)
	if [ $WHOAMI = 'root' ]; then
		echo "You can't do this as root"
	else
		doas bash -c "\
		doas -u $WHOAMI killall firefox;\
		doas -u $WHOAMI mkdir /tmp/omni
		cd /tmp/omni
		doas -u $WHOAMI unzip -oq /usr/lib64/firefox/omni.ja
		doas -u $WHOAMI rm -rf dictionaries
		doas -u $WHOAMI rm -rf hyphenation
		doas -u $WHOAMI rm -rf localization
		doas -u $WHOAMI sed -i '/const SECURITY_STATE_SIGNER = /c\const SECURITY_STATE_SIGNER = \"\";' modules/psm/RemoteSecuritySettings.sys.mjs
		doas -u $WHOAMI sed -i '/const DEFAULT_SIGNER = /c\const DEFAULT_SIGNER = \"\";' modules/services-settings/remote-settings.sys.mjs
		doas -u $WHOAMI sed -i '/MOZ_NORMANDY/!b;n;c\ \ false,' modules/AppConstants.sys.mjs
		doas -u $WHOAMI sed -i '/REMOTE_SETTINGS_SERVER_URL/!b;n;c\ \ \ \ \"\",' modules/AppConstants.sys.mjs
		doas -u $WHOAMI sed -i '/firefox.settings.services.mozilla.com/c\ \ \ \ \ \ \"\",' modules/SearchUtils.sys.mjs
		doas -u $WHOAMI sed -i 's/remote-settings.content-signature.mozilla.org//g' modules/services-settings/remote-settings.sys.mjs
		doas -u $WHOAMI zip -0DXqr omni.ja *
		cp omni.ja /usr/lib64/firefox/omni.ja
		cp --force --reflink=auto /home/$WHOAMI/Configuration/policies.json /usr/lib64/firefox/distribution/policies.json;\
		doas -u $WHOAMI rm --recursive --force /home/$WHOAMI/.local/share/firefoxpwa/runtime/*;\
		doas -u $WHOAMI cp --recursive --force --reflink=always /usr/lib64/firefox/* /home/$WHOAMI/.local/share/firefoxpwa/runtime;\
		doas -u $WHOAMI /home/$WHOAMI/Configuration/updater.sh -bsu -p /home/$WHOAMI/.mozilla/firefox/tiuh6kpf.default;\
		doas -u $WHOAMI /home/$WHOAMI/Configuration/updater.sh -bsu -p /home/$WHOAMI/.mozilla/firefox/3v4f2jgx.Vanilla;\
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
		cp --force --reflink=auto $GENTOO_CONFIG_DIR/linux/.config /usr/src/linux/.config;\
		cd /usr/src/linux;\
		make oldconfig;\
		make -j6;\
		find /boot -mindepth 1 -not -name 'memtest.efi64' -delete;\
		rm --recursive --force /lib/modules/*;\
		grub-install --efi-directory=/efi;\
		kernelVer=\$(doas -u $WHOAMI make --no-print-directory kernelversion);\
		make install;\
		mv /boot/vmlinuz /boot/vmlinuz-\$kernelVer;\
		dracut --force --kver \$kernelVer;\
		snapper --config root create --type post --pre-number \$preNum --description \$kernelVer --cleanup-algorithm number;\
		grub-mkconfig -o /boot/grub/grub.cfg;\
		doas -u $WHOAMI cp --force --reflink=auto /usr/src/linux/.config $GENTOO_CONFIG_DIR/linux/.config"
	fi
}

kernel-config () {
	local WHOAMI=$(whoami)
	if [ $WHOAMI = 'root' ]; then
		echo "You can't do this as root"
	else
		doas bash -c "\
		cp --force --reflink=auto $GENTOO_CONFIG_DIR/linux/.config /usr/src/linux/.config;\
		cd /usr/src/linux;\
		make menuconfig;\
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
