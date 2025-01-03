#!/bin/busybox sh

# Mount the /dev, /dev/pts, /proc and /sys filesystems.
mount -nt devtmpfs none /dev
mkdir /dev/pts
mount -nt devpts none /dev/pts
mount -nt proc none /proc
mount -nt sysfs none /sys

ifconfig eth0 up
udhcpc -t 5 -q -s /bin/dhcp.sh

sleep 5

if [ -e /dev/mmcblk2p4 ]; then
	dropbear -R -F -I 600 -j -k -s -c "cryptsetup --allow-discards --perf-no_read_workqueue --perf-no_write_workqueue open /dev/mmcblk2p4 CryptRoot; if [ -e /dev/mapper/CryptRoot ]; then killall dropbear; fi"
elif [ -e /dev/sda4 ]; then
	dropbear -R -F -I 600 -j -k -s -c "cryptsetup --allow-discards --perf-no_read_workqueue --perf-no_write_workqueue open /dev/sda4 CryptRoot; if [ -e /dev/mapper/CryptRoot ]; then killall dropbear; fi"
else
	dropbear -R -F -I 600 -j -k -s
fi

mount -nt btrfs -o noacl,autodefrag,compress-force=zstd,datacow,datasum,discard=async,space_cache=v2,ssd_spread,noatime,rw,suid,dev,exec,async /dev/mapper/CryptRoot /mnt/root

umount /sys
umount /proc
umount /dev/pts
umount /dev

exec switch_root /mnt/root /sbin/init
