find /usr/src -mindepth 1 -maxdepth 1 -not -name 'linux' -not -name $(readlink /usr/src/linux) -exec rm -rf {}
cd /usr/src/linux
make clean
emerge --ask --depclean
eclean distfiles
eclean packages
CCACHE_DIR=/var/cache/ccache/ doas -u $DOAS_USER ccache -C
doas -u $DOAS_USER rm --recursive --force /home/$DOAS_USER/.npm
doas -u $DOAS_USER rm --recursive --force /home/$DOAS_USER/.pki
doas -u $DOAS_USER rm --recursive --force /home/$DOAS_USER/.cache