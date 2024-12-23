# VM setup
virsh create /etc/libvirt/qemu/<vm-name>.xml
virt-xml <DOMAIN> --edit --confirm --qemu-commandline '-accel thread=multi'

# List of commands for new install from gentoo-install-media
# 1- Get install media network connectivity
ifconfig
dhcpcd enp1s0
nano /etc/resolv.conf
# nameserver 9.9.9.9

# 2- Preparing the disk
lsblk -o name,label,partlabel,size,mountpoint
gdisk /dev/vda
	o
		y
	x
		l
			1
		m
	n
		1
		64
		16383
		ffffffff-ffff-ffff-ffff-ffffffffffff
	c
		1
		UBoot TPL SPL
	n
		2
		16384
		32767
		ffffffff-ffff-ffff-ffff-ffffffffffff
	c
		2
		UBoot Core
	x
		l
			2048
		m
	n
		3
		32768
		+128M
		ef00
	n
		4
		294912
		<default>
		8309
	w
		y
mkfs.fat -v -F 16 -n "ESP" /dev/vda3
cryptsetup luksFormat --type luks2 /dev/vda4
cryptsetup --allow-discards --perf-no_read_workqueue --perf-no_write_workqueue --persistent open /dev/vda4 CryptRoot
mkfs.btrfs --verbose --label "Gentoo Linux" --data dup --metadata dup /dev/mapper/CryptRoot
mount --types btrfs --options noacl,autodefrag,compress-force=zstd,datacow,datasum,discard=async,space_cache=v2,ssd_spread,noatime,rw,suid,dev,exec,auto,nouser,async /dev/mapper/CryptRoot /mnt/gentoo
mkdir --parents /mnt/gentoo/efi
mount --types vfat --options discard,utf8,noatime,rw,nosuid,nodev,noexec,auto,nouser,async /dev/vda3 /mnt/gentoo/efi

# 3- Installing the Gentoo files
# See https://distfiles.gentoo.org/releases/arm64/autobuilds/current-stage3-arm64-openrc/
wget <Stage 3 URL>
wget <Stage 3 asc URL>
gpg --import /usr/share/openpgp-keys/gentoo-release.asc
gpg --verify <Stage 3 asc File>
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner -C /mnt/gentoo

# 4- Mounting the system
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
arch-chroot /mnt/gentoo

# 5- Configure the system
emerge-webrsync
eselect profile list
eselect profile set </23.0/hardened>
ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime
nano /etc/locale.gen
	en_CA.UTF-8 UTF-8
	en_CA ISO-8859-1
locale-gen
eselect locale list
eselect locale set <en_CA.utf8>
env-update && source /etc/profile
passwd
useradd --create-home --groups users,wheel --shell /bin/bash charles
passwd charles
nano /etc/portage/make.conf
	MAKEOPTS="-j6"
	EMERGE_DEFAULT_OPTS="--jobs 3"
emerge --ask --oneshot --quiet dev-vcs/git app-admin/doas app-portage/eix
su charles
cd
mkdir Git
cd Git
git clone https://github.com/charlesetienne-cote/gentoo-config.git
cd gentoo-config
git switch RockPro64-Server
exit
cp /home/charles/Git/gentoo-config/etc/doas.conf /etc/doas.conf
su charles
cd /home/charles/Git/gentoo-config
bash apply-config.sh
exit
rm -rf /var/db/repos/gentoo
eix-sync

# 6- Create initramfs
emerge --ask sys-apps/busybox sys-fs/cryptsetup net-misc/dropbear sys-kernel/gentoo-sources
mkdir --parents /usr/src/initramfs/{bin,etc,dev,lib,lib64,mnt/root,proc,sys}
cp --archive /dev/console /usr/src/initramfs/dev/
ln --symbolic busybox /usr/src/initramfs/bin/sh
nano /usr/src/initramfs/init
nano /usr/src/initramfs/bin/dhcp.sh
chmod +x /usr/src/initramfs/init
chmod +x /usr/src/initramfs/bin/dhcp.sh
lddtree /usr/bin/busybox
cp /usr/bin/busybox /usr/src/initramfs/bin/busybox
lddtree /usr/bin/cryptsetup
cp /usr/bin/cryptsetup /usr/src/initramfs/bin/cryptsetup
cp /usr/lib64/libcryptsetup.so.12 /usr/src/initramfs/lib64/libcryptsetup.so.12
cp /usr/lib64/libdevmapper.so.1.02 /usr/src/initramfs/lib64/libdevmapper.so.1.02
cp /usr/lib64/libm.so.6 /usr/src/initramfs/lib64/libm.so.6
cp /usr/lib64/libnettle.so.8 /usr/src/initramfs/lib64/libnettle.so.8
cp /usr/lib64/libargon2.so.1 /usr/src/initramfs/lib64/libargon2.so.1
cp /usr/lib64/libjson-c.so.5 /usr/src/initramfs/lib64/libjson-c.so.5
cp /usr/lib64/libpopt.so.0 /usr/src/initramfs/lib64/libpopt.so.0
cp /usr/lib64/libuuid.so.1 /usr/src/initramfs/lib64/libuuid.so.1
cp /usr/lib64/libblkid.so.1 /usr/src/initramfs/lib64/libblkid.so.1
cp /usr/lib64/libc.so.6 /usr/src/initramfs/lib64/libc.so.6
cp /lib/ld-linux-aarch64.so.1 /usr/src/initramfs/lib/ld-linux-aarch64.so.1
cp /usr/lib/gcc/aarch64-unknown-linux-gnu/13/libgcc_s.so.1 /usr/src/initramfs/lib64/libgcc_s.so.1
lddtree /usr/bin/dropbear
cp /usr/bin/dropbear /usr/src/initramfs/bin/dropbear
cp /usr/lib64/libtomcrypt.so.1 /usr/src/initramfs/lib64/libtomcrypt.so.1
cp /usr/lib64/libgmp.so.10 /usr/src/initramfs/lib64/libgmp.so.10
cp /usr/lib64/libtommath.so.1 /usr/src/initramfs/lib64/libtommath.so.1
cp /usr/lib64/libz.so.1 /usr/src/initramfs/lib64/libz.so.1
cp /usr/lib64/libcrypt.so.2 /usr/src/initramfs/lib64/libcrypt.so.2
cp /lib64/libnss_compat.so.2 /usr/src/initramfs/lib64/libnss_compat.so.2
cp /lib64/libnss_files.so.2 /usr/src/initramfs/lib64/libnss_files.so.2
echo "root:x:0:0:root:/root:/bin/sh" > /usr/src/initramfs/etc/passwd
echo "root:*:::::::" > /usr/src/initramfs/etc/shadow
echo "root:x:0:root" > /usr/src/initramfs/etc/group
echo "/bin/sh" > /usr/src/initramfs/etc/shells
chmod 640 /usr/src/initramfs/etc/shadow
cat << EOF > /usr/src/initramfs/etc/nsswitch.conf
passwd:	files
shadow:	files
group:	files
EOF
# Sur machine locale
ssh-keygen -t rsa -f ~/.ssh/unlock_remote
scp ~/.ssh/unlock_remote.pub root@192.168.122.125:/mnt/gentoo/
# Sur serveur
cp /unlock_remote.pub /usr/src/initramfs/root/.ssh/authorized_keys
chmod 0600 /usr/src/initramfs/root/.ssh/authorized_keys

# 7- Installkernel
cd /usr/src/linux
mkdir --parent /efi/EFI/BOOT
make -j6
cp /usr/src/linux/arch/arm64/boot/Image /efi/EFI/BOOT/BOOTAA64.EFI
