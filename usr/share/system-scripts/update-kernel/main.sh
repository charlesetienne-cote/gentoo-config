eselect kernel list
echo "New Kernel"
read kernelPos
eselect kernel set $kernelPos
cp --force --reflink=auto $GENTOO_CONFIG_DIR/linux/.config /usr/src/linux/.config
cd /usr/src/linux
make oldconfig
make -j6
find /boot -mindepth 1 -not -name 'memtest.efi64' -delete
rm --recursive --force /lib/modules/*
grub-install --efi-directory=/efi --force
kernelVer=$(doas -u $DOAS_USER make --no-print-directory kernelversion)
make install
mv /boot/vmlinuz /boot/vmlinuz-$kernelVer
dracut --force --kver $kernelVer
grub-mkconfig -o /boot/grub/grub.cfg
doas -u $DOAS_USER cp --force --reflink=auto /usr/src/linux/.config $GENTOO_CONFIG_DIR/linux/.config