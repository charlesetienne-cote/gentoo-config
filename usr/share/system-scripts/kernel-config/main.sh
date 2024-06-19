cp --force --reflink=auto $GENTOO_CONFIG_DIR/linux/.config /usr/src/linux/.config
cd /usr/src/linux
make menuconfig
doas -u $DOAS_USER cp --force --reflink=auto /usr/src/linux/.config $GENTOO_CONFIG_DIR/linux/.config