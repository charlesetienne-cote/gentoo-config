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
emerge --ask --oneshot --quiet dev-vcs/git
su charles
cd
mkdir Git
cd Git
git clone https://github.com/charlesetienne-cote/gentoo-config.git
cd gentoo-config
bash apply-config.sh

# 6- Install bootloader and kernel